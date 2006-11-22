import cgi
import re

import dns.resolver
from formencode import Invalid, validators, schema

from zookeepr.model import Person, ProposalType, Stream

class BaseSchema(schema.Schema):
    allow_extra_fields = True
    filter_extra_fields = True

    def validate(self, input, state=None):
        try:
            result = self.to_python(input, state)
            return result, {}
        except Invalid, e:
            errors = e.unpack_errors()
            # e.unpack_errors() doesn't necessarily return a nice dictionary
            # for formfill to use, so re-mangle it
            good_errors = {}
            try:
                for key in errors.keys():
                    try:
                        for subkey in errors[key].keys():
                            good_errors[key + "." + subkey] = errors[key][subkey]
                    except AttributeError:
                        good_errors[key] = errors[key]
            except AttributeError:
                good_errors['x'] = errors
                
            return {}, good_errors


class PersonValidator(validators.FancyValidator):
    def _to_python(self, value, state):
        return Person.get(value)


class ProposalTypeValidator(validators.FancyValidator):
    def _to_python(self, value, state):
        return state.query(ProposalType).get(value)


class FileUploadValidator(validators.FancyValidator):
    def _to_python(self, value, state):
        if isinstance(value, cgi.FieldStorage):
            filename = value.filename
            content = value.value
        elif isinstance(value, str):
            filename = None
            content = value
        return dict(filename=filename,
                    content=content)


class StreamValidator(validators.FancyValidator):
    def _to_python(self, value, state):
        return state.query(Stream).get(value)


class ReviewSchema(schema.Schema):
    familiarity = validators.Int()
    technical = validators.Int()
    experience = validators.Int()
    coolness = validators.Int()
    stream = StreamValidator()
    comment = validators.String()


class EmailAddress(validators.FancyValidator):
    """Validator for email addresses.

    We override the FormEncode Email validator because it doesn't
    allow domains that have A records but no MX, and doesn't like
    'localhost'.
    """

    usernameRE = re.compile(r"^[^ \t\n\r@<>()]+$", re.I)
    domainRE = re.compile(r"^[a-z0-9][a-z0-9\.\-_]*\.[a-z]+$|^localhost$", re.I)

    messages = {
        'empty': 'Please enter an email address',
        'noAt': 'An email address must contain a single @',
        'badUsername': 'The username portion of the email address is invalid (the portion before the @: %(username)s)',
        'badDomain': 'The domain portion of the email address is invalid (the portion after the @: %(domain)s)',
        'domainDoesNotExist': 'The domain of the email address does not exist (the portion after the @: %(domain)s)',
        'socketError': 'An error occurred when trying to connect to the server: %(error)s',
        'dnsTimeout': 'A temporary error occurred whilst trying to validate your email address, please try again in a moment.',
        }

    def __init__(self, *args, **kwargs):
        super(EmailAddress, self).__init__(*args, **kwargs)

    def validate_python(self, value, state):
        if not value:
            raise Invalid(self.message('empty', state), value, state)
        value = value.strip()
        splitted = value.split('@', 1)
        if not len(splitted) == 2:
            raise Invalid(self.message('noAt', state), value, state)
        if not self.usernameRE.search(splitted[0]):
            raise Invalid(self.message('badUsername', state, username=splitted[0]), value, state)
        if not self.domainRE.search(splitted[1]):
            raise Invalid(self.message('badDomain', state, domain=splitted[1]), value, state)

        # hack so example.org tests work offline
        if splitted[1] == 'example.org' or splitted[1] == 'localhost':
            domain_exists = True
        else:
            try:
                try:
                    domain_exists = dns.resolver.query(splitted[1], 'A')
                except (dns.resolver.NoAnswer, dns.resolver.NXDOMAIN):
                    pass
                try:
                    domain_exists = dns.resolver.query(splitted[1], 'MX')
                except (dns.resolver.NoAnswer, dns.resolver.NXDOMAIN):
                    pass
            except dns.resolver.Timeout:
                raise Invalid(self.message('dnsTimeout', state, domain=splitted[1]), value, state)
            if domain_exists == False:
                raise Invalid(self.message('domainDoesNotExist', state, domain=splitted[1]), value, state)

    def _to_python(self, value, state):
        return value.strip()
