import logging
from formencode import validators, variabledecode
from formencode.schema import Schema
from zookeepr.lib.base import *
from zookeepr.lib.auth import *
from zookeepr.lib.crud import *
from zookeepr.lib.validators import BaseSchema, BoundedInt, DbContentTypeValidator
from zookeepr.lib.base import *
from zookeepr.controllers import not_found
from zookeepr.model.db_content import DBContentType
from pylons import response
from zookeepr.config.lca_info import file_paths

from webhelpers.pagination import paginate

log = logging.getLogger(__name__)

# Code taken from http://jimmyg.org/2007/09/25/file-uploads-in-python/ . License undefined... I'm assuming under the same license as pylons (GPL)
import os
import shutil
import cgi

class ProgressFile(file):
    def write(self, *k, **p):
        if hasattr(self, 'callback'):
            self.callback(self, *k, **p)
        return file.write(self, *k,**p)

    def set_callback(self, callback):
        self.callback = callback

def stream(file_object):
    class CustomFieldStorage(cgi.FieldStorage):
        def make_file(self, binary=None):
            self.open_file = file_object
            return self.open_file
    return CustomFieldStorage

class DbContentSchema(BaseSchema):
    title = validators.String(not_empty=True)
    type = DbContentTypeValidator()
    url = validators.String()
    body = validators.String()

class NewContentSchema(BaseSchema):
    db_content = DbContentSchema()
    pre_validators = [variabledecode.NestedVariables]

class UpdateContentSchema(BaseSchema):
    db_content = DbContentSchema()
    pre_validators = [variabledecode.NestedVariables]

class DbContentController(SecureController, Create, List, Read, Update, Delete):
    individual = 'db_content'
    model = model.DBContent
    schemas = {'new': NewContentSchema(),
               'edit': UpdateContentSchema()
              }

    permissions = {'new': [AuthRole('organiser')],
                   'index': [AuthRole('organiser')],
                   'page': True,
                   'view': True,
                   'edit': [AuthRole('organiser')],
                   'delete': [AuthRole('organiser')],
                   'list_news': True,
                   'list_press': True,
                   'rss_news': True,
                   'upload': [AuthRole('organiser')],
                   'list_files': [AuthRole('organiser')]
                   }

    def __before__(self, **kwargs):
        super(DbContentController, self).__before__(**kwargs)
        c.db_content_types = self.dbsession.query(DBContentType).all()

    def view(self):
        news_id = self.dbsession.query(model.DBContentType).filter_by(name='News').first().id
        c.is_news = False
        if news_id == c.db_content.type_id:
            c.is_news = True
        return super(DbContentController, self).view()

    def page(self):
        url = h.url()()
        if url[0]=='/': url=url[1:]
        c.db_content = self.dbsession.query(model.DBContent).filter_by(url=url).first()
        if c.db_content is not None:
            return self.view()
        return not_found.NotFoundController().view()
    
    def list_news(self):
        news_id = self.dbsession.query(model.DBContentType).filter_by(name='News').first().id
        news_list = self.dbsession.query(self.model).filter_by(type_id=news_id).order_by(self.model.c.creation_timestamp.desc()).all()
        pages, collection = paginate(news_list, per_page = 20)
        setattr(c, self.individual + '_pages', pages)
        setattr(c, self.individual + '_collection', collection)
        return render_response('%s/list_news.myt' % self.individual)
    
    def rss_news(self):
        news_id = self.dbsession.query(model.DBContentType).filter_by(name='News').first().id
        news_list = self.dbsession.query(self.model).filter_by(type_id=news_id).order_by(self.model.c.creation_timestamp.desc()).limit(20).all()
        setattr(c, self.individual + '_collection', news_list)
        response.headers['Content-type'] = 'application/rss+xml; charset=utf-8'
        return render_response('%s/rss_news.myt' % self.individual, fragment=True)

    def upload(self):
        def callback(file, *k, **p):
            log.debug("Logged %s", [file.tell()])
        print asdf
        fp = ProgressFile('zookeepr/public/somefile', 'wb')
        fp.set_callback(callback)
        custom_field_storage = stream(fp)(
            environ=request.environ,
            strict_parsing=True,
            fp=request.environ['wsgi.input']
        )
        fp.close()
        return render('%s/file_uploaded.myt' % self.individual)

    def list_files(self):
        # Taken from http://aspn.activestate.com/ASPN/Cookbook/Python/Recipe/170242
        def caseinsensitive_sort(stringList):
            """case-insensitive string comparison sort
            doesn't do locale-specific compare
            though that would be a nice addition
            usage: stringList = caseinsensitive_sort(stringList)"""

            tupleList = [(x.lower(), x) for x in stringList]
            tupleList.sort()
            return [x[1] for x in tupleList]

        directory = file_paths['public_path']
        current_path = "/"
        try:
            if request.GET['folder'] is not None:
                directory += "/" + request.GET['folder']
                current_path = request.GET['folder']
        except KeyError:
            pass
        files = []
        folders = []
        for filename in os.listdir(directory):
            print filename, directory
            if os.path.isdir(directory + "/" + filename):
                folders.append(filename + "/")
            else:
                files.append(filename)

        c.file_list = caseinsensitive_sort(files)
        c.folder_list = caseinsensitive_sort(folders)
        c.current_path = current_path
        return render('%s/list_files.myt' % self.individual)

    def list_press(self):
        press_id = self.dbsession.query(model.DBContentType).filter_by(name='In the press').first().id
        press_list = self.dbsession.query(self.model).filter_by(type_id=press_id).order_by(self.model.c.creation_timestamp.desc()).all()
        pages, collection = paginate(press_list, per_page = 20)
        setattr(c, self.individual + '_pages', pages)
        setattr(c, self.individual + '_collection', collection)
        return render_response('%s/list_press.myt' % self.individual)
