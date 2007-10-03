<fieldset id="personal">

<h2>Personal Information</h2>

<br><p class="note">
<span class="mandatory">*</span> - Mandatory field
</p>

<p class="label">
<span class="mandatory">*</span>
<label for="registration.address">Address:</label>
</p><p class="entries">
<% h.text_field('registration.address1', size=40) %>
<br />
<% h.text_field('registration.address2', size=40) %>
</p>
<p class="label">
<span class="mandatory">*</span>
<label for="registration.city">City/Suburb:</label>
</p><p class="entries">
<% h.text_field('registration.city', size=40) %>
</p><p class="label">
<label for="registration.state">State/Province:</label>
</p><p class="entries">
<% h.text_field('registration.state', size=40) %>
</p><p class="label">
<span class="mandatory">*</span>
<label for="registration.country">Country:</label>
</p><p class="entries">
<% h.text_field('registration.country', size=40) %>
</p><p class="label">
<span class="mandatory">*</span>
<label for="registration.postcode">Postcode/ZIP:</label>
</p><p class="entries">
<% h.text_field('registration.postcode', size=40) %>
</p>

</p><p class="label">
<label for="registration.phone">Mobile/Cell number:</label>
</p><p class="entries">
<% h.text_field('registration.phone') %>
</p>

</p><p class="label">
<label for="registration.company">Company:</label>
</p><p class="entries">
<% h.text_field('registration.company', size=60) %>
</p>

<p class="label">
# FIXME: dynamic :)
<label for="registration.shell">Your favourite shell:</label>
</p><p class="entries">
<select name="registration.shell">
<option value="-">-</option>
% for s in ['zsh', 'bash', 'sh', 'csh', 'tcsh', 'emacs', 'ksh', 'smrsh', 'busybox', 'dash', 'XTree Gold']:
<option value="<%s%>"><% s %></option>
% #endfor
</SELECT>
Other: <% h.text_field('registration.shelltext') %>
</p>

<p class="label">
<label for="registration.editor">Your favourite editor:</label>
</p><p class="entries">
<SELECT name="registration.editor">
<option value="-">-</option>
% for e in ['vi', 'vim', 'emacs', 'xemacs', 'gedit', 'nano', 'kate', 'jed']:
<option value="<% e %>"><% e %></option>
% #endfor
</SELECT>
Other: <% h.text_field('registration.editortext') %>
</p>

<p class="label">
<label for="registration.distro">Your favourite distro:</label>
</p><p class="entries">
<SELECT name="registration.distro">
<option value="-">-</option>
% for d in ['CentOS', 'Darwin', 'Debian', 'Fedora', 'FreeBSD', 'Gentoo', 'L4', 'Mandriva', 'NetBSD', 'OpenBSD', 'OpenSolaris', 'OpenSUSE', 'RHEL', 'Slackware', 'Ubuntu']:
<option value="<% d %>"><% d %></option>
% #endfor
</SELECT>
Other: <% h.text_field('registration.distrotext') %>
</p>

</p><p class="label">
<label for="registration.nick">Superhero name:</label>
</p><p class="entries">
<% h.text_field('registration.nick', size=30) %>
</p><p class="note">
Your IRC nick or other handle you go by.
</p>

<%python>
starts = ["a", "a", "a", "one", "no"] # bias toward "a"
adverbs = ["strongly",
		       "poorly", "badly", "well", "dynamically",
		       "hastily", "statically", "mysteriously",
		       "buggily", "extremely", "nicely", "strangely",
		       "irritatingly", "unquestionably", "clearly",
		       "plainly", "silently", "abstractly", "validly",
		       "invalidly", "immutably", "oddly", "disturbingly",
		       "atonally", "randomly", "amusingly", "widely",
		       "narrowly", "manually", "automatically", "audibly",
		       "brilliantly", "independently", "definitively",
		       "provably", "improbably", "distortingly",
		       "confusingly", "decidedly", "historically"]
adjectives = ["invalid", "valid",
		       "referenced", "dereferenced", "unreferenced",
		       "illegal", "legal",
		       "questionable", 
		       "alternate", "implemented", "unimplemented",
		       "terminal", "non-terminal",
		       "static", "dynamic",
		       "qualified", "unqualified", 
		       "constant", "variable",
		       "volatile", "non-volatile",
		       "abstract", "concrete",
		       "fungible", "non-fungible",
		       "untyped", "variable",
		       "mutable", "immutable",
		       "sizable", "miniscule",
		       "perverse", "immovable",
		       "compressed", "uncompressed",
		       "surreal", "allegorical",
		       "trivial", "nontrivial"]
nouns = ["pointer", "structure",
		       "definition", "declaration", "type", "union",
		       "coder", "admin", "hacker", "kitten", "mistake",
		       "conversion", "implementation", "design", "analysis",
		       "neophyte", "expert", "bundle", "package",
		       "abstraction", "theorem", "display", "distro",
		       "restriction", "device", "function", "reference"]
adverb = random.choice(adverbs)
adjective = random.choice(adjectives)
noun = random.choice(nouns)
start = random.choice(starts)
if start == 'a' and adverb[0] in ['a', 'e', 'i', 'o', 'u']:
    start = 'an'
desc = '%s %s %s %s' % (start, adverb, adjective, noun)
descMD5 = md5.new(desc).hexdigest()
</%python>
<p class="label">
<label for="registration.silly_description">Description:</label>
</p><p>
<% desc %>
<% h.hidden_field('registration.silly_description', value=desc) %>
</p>

<p class="label">
<label for="registration.prevlca">Have you attended linux.conf.au before?</label>
</p><p class="entries">
% for (year, desc) in [('99', '1999 (CALU, Melbourne)'), ('01', '2001 (Sydney)'), ('02', '2002 (Brisbane)'), ('03', '2003 (Perth)'), ('04', '2004 (Adelaide)'), ('05', '2005 (Canberra)'), ('06', '2006 (Dunedin)'), ('07', '2007 (Sydney)')]:
%	label = 'registration.prevlca.%s' % year
<br />
<% h.check_box(label) %>
<label for="<% label %>"><% desc %></label>
% #endfor
</p>


</fieldset>

<fieldset id="registration">
<h2>Conference Information</h2>

<br><p class="note">
<span class="mandatory">*</span> - Mandatory field
</p>

% if 'signed_in_person_id' in session:
%   proposals = c.signed_in_person.proposals
%   is_speaker = reduce(lambda a, b: a or b.accepted, proposals, False)
% else:
%   proposals = []
%   is_speaker = False
% #endif

<p class="label">
<span class="mandatory">*</span>
<label for="registration.type">What type of ticket do you want?</label>
</p><p class="entries">
# FIXME: dynamic content
% ticket_types = [('Professional', '748.00', '598.40'), ('Hobbyist', '352.00', '281.60'), ('Concession', '154.00', '154.00')]
% if is_speaker:
%   ticket_types = [('Speaker', '0.00', '0.00')] + ticket_types
% #endif
% for (t, p, eb) in ticket_types:
<input type="radio" name="registration.type" id="registration.type_<% t %>" value="<% t %>" />
<label for="registration.type_<% t %>"><% t %> - $<% p %></label>
<br />
% #endfor
<p class="note">
Check the <% h.link_to('registration page', url="/Registration", popup=True) %> for the full details of each ticket.
</p>

% if 0:
<p class="label">
<label for="registration.discount_code">Discount Code:</label>
</p><p class="entries">
<% h.text_field('registration.discount_code') %>
</p>
% else:
<% h.hidden_field('registration.discount_code', value='') %>
% #endif

<p class="label">
<span class="mandatory">*</span>
<label>Teeshirt Size:</label>
<p class="entries">
<table>
# FIXME:
% for sex in ['M', 'F']:
<tr>
<td>
%	if sex == 'M':
Male:
%	else:
Female:
%	#endif
</td>
% 	for size, size_text in [('S', 'Small'), ('M', 'Medium'), ('L', 'Large'), ('XL', 'X Large'), ('XXL', 'XX Large'), ('XXXL', 'XXX Large')]:
<td>
<input type="radio" name="registration.teesize" id="registration.teesize_<% sex %>_<% size %>" value="<% sex %>_<% size %>" />
<label for="registration.teesize_<% sex %>_<% size %>"><% size_text %></label>
</td>
% 	#endfor
</tr>
% #endfor
</table>
</p>

<p class="label">
<label for="registration.dinner">I'd like this many extra Penguin Dinner Tickets:</label>
</p><p class="entries">
<SELECT id="registration.dinner" name="registration.dinner">
<option value="0">0</option>
<option value="1">1</option>
<option value="2">2</option>
</SELECT> <label> - $60 each </label>
<p class="note">
The Penguin Dinner is included in the price of a Professional delegate ticket.  Concession and Hobbyist delegates will need to purchase a Penguin Dinner ticket if they wish to attend.
</span>
</p>

<p class="label">
<label for="registration.diet">Dietary requirements:</label>
</p><p class="entries">
<% h.text_field('registration.diet', size=100) %>
</p>

<p class="label">
<label for="registration.special">Other special requirements</label>
</p><p class="entries">
<% h.text_field('registration.special', size=100) %>
</p><p class="note">
Please enter any requirements if necessary; access requirements, etc.
</p>

<p class="label">
<label for="registration.miniconfs">Prefered miniconfs:</label>
</p><p class="entries">

# FIXME: CLEARLY this needs to be dynamic

% for mc in ['Debian', 'Embedded', 'Education', 'FOSS in Research', 'FOSS in Movies', 'Gaming', 'GNOME', 'Kernel', 'Linuxchix', 'MySQL', 'OpenOffice.org', 'PostgreSQL', 'Virtualisation']:
% 	l = 'registration.miniconf.%s' % mc.replace(' ', '_')
<br />
<% h.check_box(l) %>
<label for="<% l %>"><% mc %></label>
% #endfor

<p class="note">
Please check the <% h.link_to('Miniconfs', url="/mini-confs") %> page for details on each event. You can choose to attend multiple miniconfs in the one day, as the schedules will be published ahead of the conference for you to swap sessions.
</p>

<p class="label">
<label for="registration.opendaydrag">How many people are you bringing to <% h.link_to("Open Day", url="/OpenDay", popup=True) %>:</label>
</p><p class="entries">
<% h.text_field('registration.opendaydrag', size=10) %>
</p><p class="note">
Open Day is open to friends and family, and is targetted to a non-technical audience.  If you want to show off FOSS culture to some people, you can give us an idea of how many people to expect.
</p>

</fieldset>

<fieldset id="accommodation">
<h2>Accommodation</h2>

<br><p class="note">
<span class="mandatory">*</span> - Mandatory field
</p>


<p>
Please check out the <% h.link_to('accommodation', url="/Accommodation", popup=True) %> page before committing to any accommodation choices.
</p>

<p class="label">
<span class="mandatory">*</span>
<label for="registration.accommodation">What accommodation would you like to stay at:</label>
</p><p class="entries">
<SELECT name="registration.accommodation">
<option value="0">I will organise my own</option>
% for a in c.accommodation_collection:
<option value="<% a.id %>"><% a.name %>
% 	if a.option:
(<% a.option %>)
% 	#endif
- <% h.number_to_currency(a.cost_per_night) %> per night (<% a.beds - a.beds_taken %> places left)</option>
% #endfor
</SELECT>
</p>

<p class="label">
<span class="mandatory">*</span>
<label for="registration.checkin">Check in on:</label>
</p><p class="entries">
<select name="registration.checkin">
% for d in range(14, 21):
<option value="<% d %>"><% datetime.datetime(2007, 1, d).strftime('%A, %d %b') %></option>
% #endfor
</select>
</p>

<p class="label">
<span class="mandatory">*</span>
<label for="registation.checkout">Check out on:</label>
</p><p class="entries">
<select name="registration.checkout">
% for d in range(15, 22):
<option value="<% d %>"
% 	if d == 20:
selected
% 	#endif
><% datetime.datetime(2007, 1, d).strftime('%A, %d %b') %></option>
% #endfor
</select>
</p>
</fieldset>

<fieldset id="partners">
<h2>Partners Programme</h2>

<p class="label">
<label for="registration.partner_email">Your partner's email address:</label>
</p><p class="entries">
<% h.text_field('registration.partner_email', size=50) %>
</p><p class="note">
If you are planning on bringing your partner, please enter their email address here so that our <% h.link_to('Partners Programme', url="/PartnersProgramme", popup=True) %> manager can contact them.  <% h.link_to("Contact us", url="/PartnersProgramme", popup=True) %> if you have any problems registering your partner for the programme.
</p>

<p class="label">
<label for="registration.children">Are you bringing children?</label>
</p><p class="entries">
<label for="registration.kids_0_3">This many under 3 year olds:</label>
<% h.text_field('registration.kids_0_3', size=10) %>
<br />
<label for="registration.kids_4_6">This many 4-6 year olds:</label>
<% h.text_field('registration.kids_4_6', size=10) %>
<br />
<label for="registration.kids_7_9">This many 7-9 year olds:</label>
<% h.text_field('registration.kids_7_9', size=10) %>
<br />
<label for="registration.kids_10">This many aged 10 or above:</label>
<% h.text_field('registration.kids_10', size=10) %>
<br />
</p>
</fieldset>

<fieldset>
<h2>Subscriptions</h2>

<p class="entries">
<% h.check_box('registration.lasignup') %>
<label for="registration.lasignup">I want to sign up for (free) Linux Australia membership!</label>
</p>

<p class="entries">
<% h.check_box('registration.announcesignup') %>
<label for="registration.announcesignup">I want to sign up to the low traffic conference announcement mailing list!</label>
</p>

<p class="entries">
<% h.check_box('registration.delegatesignup') %>
<label for="registration.delegatesignup">I want to sign up to the conference attendees mailing list!</label>
</p>

</fieldset>

<% h.hidden_field('registration.silly_description_md5', value=descMD5) %>
<%init>
import datetime
import md5
import random
</%init>
