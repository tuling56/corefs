# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: test.proto

import sys
_b=sys.version_info[0]<3 and (lambda x:x) or (lambda x:x.encode('latin1'))
from google.protobuf import descriptor as _descriptor
from google.protobuf import message as _message
from google.protobuf import reflection as _reflection
from google.protobuf import symbol_database as _symbol_database
from google.protobuf import descriptor_pb2
# @@protoc_insertion_point(imports)

_sym_db = _symbol_database.Default()




DESCRIPTOR = _descriptor.FileDescriptor(
  name='test.proto',
  package='chen_demo',
  syntax='proto2',
  serialized_pb=_b('\n\ntest.proto\x12\tchen_demo\"N\n\tchen_info\x12\x0b\n\x03\x61ge\x18\x01 \x02(\x05\x12\x0c\n\x04name\x18\x02 \x02(\t\x12\x0c\n\x04game\x18\x03 \x02(\t\x12\n\n\x02id\x18\x04 \x01(\x05\x12\x0c\n\x04pnum\x18\x05 \x02(\t')
)
_sym_db.RegisterFileDescriptor(DESCRIPTOR)




_CHEN_INFO = _descriptor.Descriptor(
  name='chen_info',
  full_name='chen_demo.chen_info',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='age', full_name='chen_demo.chen_info.age', index=0,
      number=1, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='name', full_name='chen_demo.chen_info.name', index=1,
      number=2, type=9, cpp_type=9, label=2,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='game', full_name='chen_demo.chen_info.game', index=2,
      number=3, type=9, cpp_type=9, label=2,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='id', full_name='chen_demo.chen_info.id', index=3,
      number=4, type=5, cpp_type=1, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='pnum', full_name='chen_demo.chen_info.pnum', index=4,
      number=5, type=9, cpp_type=9, label=2,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
  ],
  extensions=[
  ],
  nested_types=[],
  enum_types=[
  ],
  options=None,
  is_extendable=False,
  syntax='proto2',
  extension_ranges=[],
  oneofs=[
  ],
  serialized_start=25,
  serialized_end=103,
)

DESCRIPTOR.message_types_by_name['chen_info'] = _CHEN_INFO

chen_info = _reflection.GeneratedProtocolMessageType('chen_info', (_message.Message,), dict(
  DESCRIPTOR = _CHEN_INFO,
  __module__ = 'test_pb2'
  # @@protoc_insertion_point(class_scope:chen_demo.chen_info)
  ))
_sym_db.RegisterMessage(chen_info)


# @@protoc_insertion_point(module_scope)