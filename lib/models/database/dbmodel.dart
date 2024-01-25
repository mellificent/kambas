import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

part 'dbmodel.g.dart';

const seqIdentity = SqfEntitySequence(
  sequenceName: 'identity',
  // maxValue:  10000, /* optional. default is max int (9.223.372.036.854.775.807) */
  // modelName: 'SQEidentity',
  /* optional. SqfEntity will set it to sequenceName automatically when the modelName is null*/
  // cycle : false,   /* optional. default is false; */
  // minValue = 0;    /* optional. default is 0 */
  // incrementBy = 1; /* optional. default is 1 */
  // startWith = 0;   /* optional. default is 0 */
);

/// tables
const tableUsers = SqfEntityTable(
    tableName: 'userAccounts',
    primaryKeyName: 'id',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    useSoftDeleting: true,
    modelName: null,
    fields: [
      SqfEntityField('userId', DbType.integer),
      SqfEntityField('userName', DbType.text),
      SqfEntityField('fullName', DbType.text),
      SqfEntityField('email', DbType.text),
      SqfEntityField('contactNo', DbType.text),
      SqfEntityField('password', DbType.text),
      SqfEntityField('createdAt', DbType.datetime),
      SqfEntityField('updatedAt', DbType.datetime),
    ]);

const tableTransaction = SqfEntityTable(
    tableName: 'kambasTransactions',
    primaryKeyName: 'id',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    useSoftDeleting: true,

    ///hindi completely nadedelete magstostore sya sa isDeleted table
    fields: [
      SqfEntityField('createdAt', DbType.datetime),
      SqfEntityField('username', DbType.text),
      SqfEntityField('ticketSeries', DbType.text,),
      SqfEntityField('jsonResponse', DbType.text),
    ]);

const tableTerminal = SqfEntityTable(
    tableName: 'kambasTerminal',
    primaryKeyName: 'id',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    useSoftDeleting: true,
    fields: [
      SqfEntityField('stallName', DbType.text, defaultValue: ""),
      SqfEntityField('location', DbType.text, defaultValue: ""),
      SqfEntityField('ticketNumber', DbType.text, defaultValue: ""),
    ]);

///database
@SqfEntityBuilder(mKambasDbModel)
const mKambasDbModel = SqfEntityModel(
    modelName: 'KambasDB',
    // optional
    databaseName: 'Kambas.db',
    password: null,
    // You can set a password if you want to use crypted database
    databaseTables: [
      tableUsers,
      tableTransaction,
      tableTerminal,
    ],
    sequences: [seqIdentity],
    bundledDatabasePath: null);
