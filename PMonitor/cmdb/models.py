from django.db import models

# Create your models here.


from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Table,Column, Integer, String,DateTime
from sqlalchemy import ForeignKey
from sqlalchemy.orm import sessionmaker,relationship




# Create your views here.

engine = create_engine("mysql+pymysql://oldboy:123456@10.0.0.52:3306/pmonitor",
					  encoding='utf-8') #echo=True表示输出执行过程

Base = declarative_base()  # 生成orm基类
# 创建与数据库的会话session class ,注意,这里返回给session的是个class,不是实例
Session_class = sessionmaker(bind=engine)
db_session = Session_class()

user_m2m_hosts_group = Table('user_m2m_hosts_group', Base.metadata,
                        Column('user_id',Integer,ForeignKey('user.id')),
                        Column('hosts_group_id',Integer,ForeignKey('hosts_group.id')),
                        )

# user_m2m_hosts = Table('user_m2m_hosts', Base.metadata,
#                         Column('user_id',Integer,ForeignKey('user.id')),
#                         Column('hosts_id',Integer,ForeignKey('hosts.id')),
#                         )


class User(Base):
	__tablename__ = 'user'  #表名
	id = Column(Integer, primary_key=True)
	name = Column(String(64))
	password = Column(String(64))
	hosts_group = relationship('Hosts_Group',secondary=user_m2m_hosts_group,backref='users')
	# hosts = relationship('Hosts',secondary=user_m2m_hosts,backref='users')

	def __repr__(self):
		return "<User(name='%s',  password='%s')>" %(self.name, self.password)


class Hosts_Group(Base):
	__tablename__ = 'hosts_group'
	id = Column(Integer, primary_key=True)
	name = Column(String(64))




class Hosts(Base):
	__tablename__ = 'hosts'  # 表名
	id = Column(Integer, primary_key=True)
	host = Column(String(64))
	ip = Column(String(32))
	port = Column(String(8))
	dns_name = Column(String(64))
	remark = Column(String(128))
	pc = Column(String(64))
	buy_year = Column(String(64))
	modify_user = Column(String(64))
	modify_datetime = Column(DateTime)
	status = Column(Integer)
	hosts_group_id = Column(Integer, ForeignKey('hosts_group.id'))
	hosts_group = relationship("Hosts_Group", backref="hosts_list")

	def __repr__(self):
		return "<User(host='%s',  ip='%s')>" %(self.host, self.ip)




def init_schema():
	# 创建表结构
	Base.metadata.create_all(engine)


def db_open():
	if db_session:
		return db_session
	else:
		db_session = Session_class()
		return db_session

def db_close():
	if db_session:
		db_session.close()

# init_schema()