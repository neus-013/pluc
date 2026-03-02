// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _passwordHashMeta =
      const VerificationMeta('passwordHash');
  @override
  late final GeneratedColumn<String> passwordHash = GeneratedColumn<String>(
      'password_hash', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _authProviderMeta =
      const VerificationMeta('authProvider');
  @override
  late final GeneratedColumn<String> authProvider = GeneratedColumn<String>(
      'auth_provider', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('local'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, username, passwordHash, authProvider, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('password_hash')) {
      context.handle(
          _passwordHashMeta,
          passwordHash.isAcceptableOrUnknown(
              data['password_hash']!, _passwordHashMeta));
    } else if (isInserting) {
      context.missing(_passwordHashMeta);
    }
    if (data.containsKey('auth_provider')) {
      context.handle(
          _authProviderMeta,
          authProvider.isAcceptableOrUnknown(
              data['auth_provider']!, _authProviderMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username'])!,
      passwordHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password_hash'])!,
      authProvider: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}auth_provider'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final String id;
  final String username;
  final String passwordHash;
  final String authProvider;
  final DateTime createdAt;
  const User(
      {required this.id,
      required this.username,
      required this.passwordHash,
      required this.authProvider,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['username'] = Variable<String>(username);
    map['password_hash'] = Variable<String>(passwordHash);
    map['auth_provider'] = Variable<String>(authProvider);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      username: Value(username),
      passwordHash: Value(passwordHash),
      authProvider: Value(authProvider),
      createdAt: Value(createdAt),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<String>(json['id']),
      username: serializer.fromJson<String>(json['username']),
      passwordHash: serializer.fromJson<String>(json['passwordHash']),
      authProvider: serializer.fromJson<String>(json['authProvider']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'username': serializer.toJson<String>(username),
      'passwordHash': serializer.toJson<String>(passwordHash),
      'authProvider': serializer.toJson<String>(authProvider),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  User copyWith(
          {String? id,
          String? username,
          String? passwordHash,
          String? authProvider,
          DateTime? createdAt}) =>
      User(
        id: id ?? this.id,
        username: username ?? this.username,
        passwordHash: passwordHash ?? this.passwordHash,
        authProvider: authProvider ?? this.authProvider,
        createdAt: createdAt ?? this.createdAt,
      );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      username: data.username.present ? data.username.value : this.username,
      passwordHash: data.passwordHash.present
          ? data.passwordHash.value
          : this.passwordHash,
      authProvider: data.authProvider.present
          ? data.authProvider.value
          : this.authProvider,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('authProvider: $authProvider, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, username, passwordHash, authProvider, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.username == this.username &&
          other.passwordHash == this.passwordHash &&
          other.authProvider == this.authProvider &&
          other.createdAt == this.createdAt);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> id;
  final Value<String> username;
  final Value<String> passwordHash;
  final Value<String> authProvider;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.passwordHash = const Value.absent(),
    this.authProvider = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
    required String username,
    required String passwordHash,
    this.authProvider = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        username = Value(username),
        passwordHash = Value(passwordHash),
        createdAt = Value(createdAt);
  static Insertable<User> custom({
    Expression<String>? id,
    Expression<String>? username,
    Expression<String>? passwordHash,
    Expression<String>? authProvider,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (passwordHash != null) 'password_hash': passwordHash,
      if (authProvider != null) 'auth_provider': authProvider,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith(
      {Value<String>? id,
      Value<String>? username,
      Value<String>? passwordHash,
      Value<String>? authProvider,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return UsersCompanion(
      id: id ?? this.id,
      username: username ?? this.username,
      passwordHash: passwordHash ?? this.passwordHash,
      authProvider: authProvider ?? this.authProvider,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (passwordHash.present) {
      map['password_hash'] = Variable<String>(passwordHash.value);
    }
    if (authProvider.present) {
      map['auth_provider'] = Variable<String>(authProvider.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('authProvider: $authProvider, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ModulesTable extends Modules with TableInfo<$ModulesTable, Module> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ModulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _enabledMeta =
      const VerificationMeta('enabled');
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
      'enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _devOnlyMeta =
      const VerificationMeta('devOnly');
  @override
  late final GeneratedColumn<bool> devOnly = GeneratedColumn<bool>(
      'dev_only', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("dev_only" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _configurableFeaturesMeta =
      const VerificationMeta('configurableFeatures');
  @override
  late final GeneratedColumn<String> configurableFeatures =
      GeneratedColumn<String>('configurable_features', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, enabled, devOnly, configurableFeatures];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'modules';
  @override
  VerificationContext validateIntegrity(Insertable<Module> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(_enabledMeta,
          enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta));
    }
    if (data.containsKey('dev_only')) {
      context.handle(_devOnlyMeta,
          devOnly.isAcceptableOrUnknown(data['dev_only']!, _devOnlyMeta));
    }
    if (data.containsKey('configurable_features')) {
      context.handle(
          _configurableFeaturesMeta,
          configurableFeatures.isAcceptableOrUnknown(
              data['configurable_features']!, _configurableFeaturesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Module map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Module(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      enabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}enabled'])!,
      devOnly: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}dev_only'])!,
      configurableFeatures: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}configurable_features']),
    );
  }

  @override
  $ModulesTable createAlias(String alias) {
    return $ModulesTable(attachedDatabase, alias);
  }
}

class Module extends DataClass implements Insertable<Module> {
  final String id;
  final String name;
  final bool enabled;
  final bool devOnly;
  final String? configurableFeatures;
  const Module(
      {required this.id,
      required this.name,
      required this.enabled,
      required this.devOnly,
      this.configurableFeatures});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['enabled'] = Variable<bool>(enabled);
    map['dev_only'] = Variable<bool>(devOnly);
    if (!nullToAbsent || configurableFeatures != null) {
      map['configurable_features'] = Variable<String>(configurableFeatures);
    }
    return map;
  }

  ModulesCompanion toCompanion(bool nullToAbsent) {
    return ModulesCompanion(
      id: Value(id),
      name: Value(name),
      enabled: Value(enabled),
      devOnly: Value(devOnly),
      configurableFeatures: configurableFeatures == null && nullToAbsent
          ? const Value.absent()
          : Value(configurableFeatures),
    );
  }

  factory Module.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Module(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      devOnly: serializer.fromJson<bool>(json['devOnly']),
      configurableFeatures:
          serializer.fromJson<String?>(json['configurableFeatures']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'enabled': serializer.toJson<bool>(enabled),
      'devOnly': serializer.toJson<bool>(devOnly),
      'configurableFeatures': serializer.toJson<String?>(configurableFeatures),
    };
  }

  Module copyWith(
          {String? id,
          String? name,
          bool? enabled,
          bool? devOnly,
          Value<String?> configurableFeatures = const Value.absent()}) =>
      Module(
        id: id ?? this.id,
        name: name ?? this.name,
        enabled: enabled ?? this.enabled,
        devOnly: devOnly ?? this.devOnly,
        configurableFeatures: configurableFeatures.present
            ? configurableFeatures.value
            : this.configurableFeatures,
      );
  Module copyWithCompanion(ModulesCompanion data) {
    return Module(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      devOnly: data.devOnly.present ? data.devOnly.value : this.devOnly,
      configurableFeatures: data.configurableFeatures.present
          ? data.configurableFeatures.value
          : this.configurableFeatures,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Module(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('enabled: $enabled, ')
          ..write('devOnly: $devOnly, ')
          ..write('configurableFeatures: $configurableFeatures')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, enabled, devOnly, configurableFeatures);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Module &&
          other.id == this.id &&
          other.name == this.name &&
          other.enabled == this.enabled &&
          other.devOnly == this.devOnly &&
          other.configurableFeatures == this.configurableFeatures);
}

class ModulesCompanion extends UpdateCompanion<Module> {
  final Value<String> id;
  final Value<String> name;
  final Value<bool> enabled;
  final Value<bool> devOnly;
  final Value<String?> configurableFeatures;
  final Value<int> rowid;
  const ModulesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.enabled = const Value.absent(),
    this.devOnly = const Value.absent(),
    this.configurableFeatures = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ModulesCompanion.insert({
    required String id,
    required String name,
    this.enabled = const Value.absent(),
    this.devOnly = const Value.absent(),
    this.configurableFeatures = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name);
  static Insertable<Module> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<bool>? enabled,
    Expression<bool>? devOnly,
    Expression<String>? configurableFeatures,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (enabled != null) 'enabled': enabled,
      if (devOnly != null) 'dev_only': devOnly,
      if (configurableFeatures != null)
        'configurable_features': configurableFeatures,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ModulesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<bool>? enabled,
      Value<bool>? devOnly,
      Value<String?>? configurableFeatures,
      Value<int>? rowid}) {
    return ModulesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      enabled: enabled ?? this.enabled,
      devOnly: devOnly ?? this.devOnly,
      configurableFeatures: configurableFeatures ?? this.configurableFeatures,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (devOnly.present) {
      map['dev_only'] = Variable<bool>(devOnly.value);
    }
    if (configurableFeatures.present) {
      map['configurable_features'] =
          Variable<String>(configurableFeatures.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ModulesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('enabled: $enabled, ')
          ..write('devOnly: $devOnly, ')
          ..write('configurableFeatures: $configurableFeatures, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FeatureTogglesTable extends FeatureToggles
    with TableInfo<$FeatureTogglesTable, FeatureToggle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FeatureTogglesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _moduleIdMeta =
      const VerificationMeta('moduleId');
  @override
  late final GeneratedColumn<String> moduleId = GeneratedColumn<String>(
      'module_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _enabledMeta =
      const VerificationMeta('enabled');
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
      'enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("enabled" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [id, moduleId, name, enabled];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'feature_toggles';
  @override
  VerificationContext validateIntegrity(Insertable<FeatureToggle> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('module_id')) {
      context.handle(_moduleIdMeta,
          moduleId.isAcceptableOrUnknown(data['module_id']!, _moduleIdMeta));
    } else if (isInserting) {
      context.missing(_moduleIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(_enabledMeta,
          enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FeatureToggle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FeatureToggle(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      moduleId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}module_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      enabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}enabled'])!,
    );
  }

  @override
  $FeatureTogglesTable createAlias(String alias) {
    return $FeatureTogglesTable(attachedDatabase, alias);
  }
}

class FeatureToggle extends DataClass implements Insertable<FeatureToggle> {
  final String id;
  final String moduleId;
  final String name;
  final bool enabled;
  const FeatureToggle(
      {required this.id,
      required this.moduleId,
      required this.name,
      required this.enabled});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['module_id'] = Variable<String>(moduleId);
    map['name'] = Variable<String>(name);
    map['enabled'] = Variable<bool>(enabled);
    return map;
  }

  FeatureTogglesCompanion toCompanion(bool nullToAbsent) {
    return FeatureTogglesCompanion(
      id: Value(id),
      moduleId: Value(moduleId),
      name: Value(name),
      enabled: Value(enabled),
    );
  }

  factory FeatureToggle.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FeatureToggle(
      id: serializer.fromJson<String>(json['id']),
      moduleId: serializer.fromJson<String>(json['moduleId']),
      name: serializer.fromJson<String>(json['name']),
      enabled: serializer.fromJson<bool>(json['enabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'moduleId': serializer.toJson<String>(moduleId),
      'name': serializer.toJson<String>(name),
      'enabled': serializer.toJson<bool>(enabled),
    };
  }

  FeatureToggle copyWith(
          {String? id, String? moduleId, String? name, bool? enabled}) =>
      FeatureToggle(
        id: id ?? this.id,
        moduleId: moduleId ?? this.moduleId,
        name: name ?? this.name,
        enabled: enabled ?? this.enabled,
      );
  FeatureToggle copyWithCompanion(FeatureTogglesCompanion data) {
    return FeatureToggle(
      id: data.id.present ? data.id.value : this.id,
      moduleId: data.moduleId.present ? data.moduleId.value : this.moduleId,
      name: data.name.present ? data.name.value : this.name,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FeatureToggle(')
          ..write('id: $id, ')
          ..write('moduleId: $moduleId, ')
          ..write('name: $name, ')
          ..write('enabled: $enabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, moduleId, name, enabled);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FeatureToggle &&
          other.id == this.id &&
          other.moduleId == this.moduleId &&
          other.name == this.name &&
          other.enabled == this.enabled);
}

class FeatureTogglesCompanion extends UpdateCompanion<FeatureToggle> {
  final Value<String> id;
  final Value<String> moduleId;
  final Value<String> name;
  final Value<bool> enabled;
  final Value<int> rowid;
  const FeatureTogglesCompanion({
    this.id = const Value.absent(),
    this.moduleId = const Value.absent(),
    this.name = const Value.absent(),
    this.enabled = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FeatureTogglesCompanion.insert({
    required String id,
    required String moduleId,
    required String name,
    this.enabled = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        moduleId = Value(moduleId),
        name = Value(name);
  static Insertable<FeatureToggle> custom({
    Expression<String>? id,
    Expression<String>? moduleId,
    Expression<String>? name,
    Expression<bool>? enabled,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (moduleId != null) 'module_id': moduleId,
      if (name != null) 'name': name,
      if (enabled != null) 'enabled': enabled,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FeatureTogglesCompanion copyWith(
      {Value<String>? id,
      Value<String>? moduleId,
      Value<String>? name,
      Value<bool>? enabled,
      Value<int>? rowid}) {
    return FeatureTogglesCompanion(
      id: id ?? this.id,
      moduleId: moduleId ?? this.moduleId,
      name: name ?? this.name,
      enabled: enabled ?? this.enabled,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (moduleId.present) {
      map['module_id'] = Variable<String>(moduleId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FeatureTogglesCompanion(')
          ..write('id: $id, ')
          ..write('moduleId: $moduleId, ')
          ..write('name: $name, ')
          ..write('enabled: $enabled, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PresetsTable extends Presets with TableInfo<$PresetsTable, Preset> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PresetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _moduleIdMeta =
      const VerificationMeta('moduleId');
  @override
  late final GeneratedColumn<String> moduleId = GeneratedColumn<String>(
      'module_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _enabledFeaturesMeta =
      const VerificationMeta('enabledFeatures');
  @override
  late final GeneratedColumn<String> enabledFeatures = GeneratedColumn<String>(
      'enabled_features', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _disabledFeaturesMeta =
      const VerificationMeta('disabledFeatures');
  @override
  late final GeneratedColumn<String> disabledFeatures = GeneratedColumn<String>(
      'disabled_features', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, moduleId, enabledFeatures, disabledFeatures];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'presets';
  @override
  VerificationContext validateIntegrity(Insertable<Preset> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('module_id')) {
      context.handle(_moduleIdMeta,
          moduleId.isAcceptableOrUnknown(data['module_id']!, _moduleIdMeta));
    } else if (isInserting) {
      context.missing(_moduleIdMeta);
    }
    if (data.containsKey('enabled_features')) {
      context.handle(
          _enabledFeaturesMeta,
          enabledFeatures.isAcceptableOrUnknown(
              data['enabled_features']!, _enabledFeaturesMeta));
    }
    if (data.containsKey('disabled_features')) {
      context.handle(
          _disabledFeaturesMeta,
          disabledFeatures.isAcceptableOrUnknown(
              data['disabled_features']!, _disabledFeaturesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Preset map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Preset(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      moduleId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}module_id'])!,
      enabledFeatures: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}enabled_features']),
      disabledFeatures: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}disabled_features']),
    );
  }

  @override
  $PresetsTable createAlias(String alias) {
    return $PresetsTable(attachedDatabase, alias);
  }
}

class Preset extends DataClass implements Insertable<Preset> {
  final String id;
  final String moduleId;
  final String? enabledFeatures;
  final String? disabledFeatures;
  const Preset(
      {required this.id,
      required this.moduleId,
      this.enabledFeatures,
      this.disabledFeatures});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['module_id'] = Variable<String>(moduleId);
    if (!nullToAbsent || enabledFeatures != null) {
      map['enabled_features'] = Variable<String>(enabledFeatures);
    }
    if (!nullToAbsent || disabledFeatures != null) {
      map['disabled_features'] = Variable<String>(disabledFeatures);
    }
    return map;
  }

  PresetsCompanion toCompanion(bool nullToAbsent) {
    return PresetsCompanion(
      id: Value(id),
      moduleId: Value(moduleId),
      enabledFeatures: enabledFeatures == null && nullToAbsent
          ? const Value.absent()
          : Value(enabledFeatures),
      disabledFeatures: disabledFeatures == null && nullToAbsent
          ? const Value.absent()
          : Value(disabledFeatures),
    );
  }

  factory Preset.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Preset(
      id: serializer.fromJson<String>(json['id']),
      moduleId: serializer.fromJson<String>(json['moduleId']),
      enabledFeatures: serializer.fromJson<String?>(json['enabledFeatures']),
      disabledFeatures: serializer.fromJson<String?>(json['disabledFeatures']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'moduleId': serializer.toJson<String>(moduleId),
      'enabledFeatures': serializer.toJson<String?>(enabledFeatures),
      'disabledFeatures': serializer.toJson<String?>(disabledFeatures),
    };
  }

  Preset copyWith(
          {String? id,
          String? moduleId,
          Value<String?> enabledFeatures = const Value.absent(),
          Value<String?> disabledFeatures = const Value.absent()}) =>
      Preset(
        id: id ?? this.id,
        moduleId: moduleId ?? this.moduleId,
        enabledFeatures: enabledFeatures.present
            ? enabledFeatures.value
            : this.enabledFeatures,
        disabledFeatures: disabledFeatures.present
            ? disabledFeatures.value
            : this.disabledFeatures,
      );
  Preset copyWithCompanion(PresetsCompanion data) {
    return Preset(
      id: data.id.present ? data.id.value : this.id,
      moduleId: data.moduleId.present ? data.moduleId.value : this.moduleId,
      enabledFeatures: data.enabledFeatures.present
          ? data.enabledFeatures.value
          : this.enabledFeatures,
      disabledFeatures: data.disabledFeatures.present
          ? data.disabledFeatures.value
          : this.disabledFeatures,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Preset(')
          ..write('id: $id, ')
          ..write('moduleId: $moduleId, ')
          ..write('enabledFeatures: $enabledFeatures, ')
          ..write('disabledFeatures: $disabledFeatures')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, moduleId, enabledFeatures, disabledFeatures);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Preset &&
          other.id == this.id &&
          other.moduleId == this.moduleId &&
          other.enabledFeatures == this.enabledFeatures &&
          other.disabledFeatures == this.disabledFeatures);
}

class PresetsCompanion extends UpdateCompanion<Preset> {
  final Value<String> id;
  final Value<String> moduleId;
  final Value<String?> enabledFeatures;
  final Value<String?> disabledFeatures;
  final Value<int> rowid;
  const PresetsCompanion({
    this.id = const Value.absent(),
    this.moduleId = const Value.absent(),
    this.enabledFeatures = const Value.absent(),
    this.disabledFeatures = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PresetsCompanion.insert({
    required String id,
    required String moduleId,
    this.enabledFeatures = const Value.absent(),
    this.disabledFeatures = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        moduleId = Value(moduleId);
  static Insertable<Preset> custom({
    Expression<String>? id,
    Expression<String>? moduleId,
    Expression<String>? enabledFeatures,
    Expression<String>? disabledFeatures,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (moduleId != null) 'module_id': moduleId,
      if (enabledFeatures != null) 'enabled_features': enabledFeatures,
      if (disabledFeatures != null) 'disabled_features': disabledFeatures,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PresetsCompanion copyWith(
      {Value<String>? id,
      Value<String>? moduleId,
      Value<String?>? enabledFeatures,
      Value<String?>? disabledFeatures,
      Value<int>? rowid}) {
    return PresetsCompanion(
      id: id ?? this.id,
      moduleId: moduleId ?? this.moduleId,
      enabledFeatures: enabledFeatures ?? this.enabledFeatures,
      disabledFeatures: disabledFeatures ?? this.disabledFeatures,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (moduleId.present) {
      map['module_id'] = Variable<String>(moduleId.value);
    }
    if (enabledFeatures.present) {
      map['enabled_features'] = Variable<String>(enabledFeatures.value);
    }
    if (disabledFeatures.present) {
      map['disabled_features'] = Variable<String>(disabledFeatures.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PresetsCompanion(')
          ..write('id: $id, ')
          ..write('moduleId: $moduleId, ')
          ..write('enabledFeatures: $enabledFeatures, ')
          ..write('disabledFeatures: $disabledFeatures, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EntityRelationsTable extends EntityRelations
    with TableInfo<$EntityRelationsTable, EntityRelation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EntityRelationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fromEntityIdMeta =
      const VerificationMeta('fromEntityId');
  @override
  late final GeneratedColumn<String> fromEntityId = GeneratedColumn<String>(
      'from_entity_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _toEntityIdMeta =
      const VerificationMeta('toEntityId');
  @override
  late final GeneratedColumn<String> toEntityId = GeneratedColumn<String>(
      'to_entity_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _relationTypeMeta =
      const VerificationMeta('relationType');
  @override
  late final GeneratedColumn<String> relationType = GeneratedColumn<String>(
      'relation_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, fromEntityId, toEntityId, relationType];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'entity_relations';
  @override
  VerificationContext validateIntegrity(Insertable<EntityRelation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('from_entity_id')) {
      context.handle(
          _fromEntityIdMeta,
          fromEntityId.isAcceptableOrUnknown(
              data['from_entity_id']!, _fromEntityIdMeta));
    } else if (isInserting) {
      context.missing(_fromEntityIdMeta);
    }
    if (data.containsKey('to_entity_id')) {
      context.handle(
          _toEntityIdMeta,
          toEntityId.isAcceptableOrUnknown(
              data['to_entity_id']!, _toEntityIdMeta));
    } else if (isInserting) {
      context.missing(_toEntityIdMeta);
    }
    if (data.containsKey('relation_type')) {
      context.handle(
          _relationTypeMeta,
          relationType.isAcceptableOrUnknown(
              data['relation_type']!, _relationTypeMeta));
    } else if (isInserting) {
      context.missing(_relationTypeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EntityRelation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EntityRelation(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      fromEntityId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}from_entity_id'])!,
      toEntityId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}to_entity_id'])!,
      relationType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}relation_type'])!,
    );
  }

  @override
  $EntityRelationsTable createAlias(String alias) {
    return $EntityRelationsTable(attachedDatabase, alias);
  }
}

class EntityRelation extends DataClass implements Insertable<EntityRelation> {
  final String id;
  final String fromEntityId;
  final String toEntityId;
  final String relationType;
  const EntityRelation(
      {required this.id,
      required this.fromEntityId,
      required this.toEntityId,
      required this.relationType});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['from_entity_id'] = Variable<String>(fromEntityId);
    map['to_entity_id'] = Variable<String>(toEntityId);
    map['relation_type'] = Variable<String>(relationType);
    return map;
  }

  EntityRelationsCompanion toCompanion(bool nullToAbsent) {
    return EntityRelationsCompanion(
      id: Value(id),
      fromEntityId: Value(fromEntityId),
      toEntityId: Value(toEntityId),
      relationType: Value(relationType),
    );
  }

  factory EntityRelation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EntityRelation(
      id: serializer.fromJson<String>(json['id']),
      fromEntityId: serializer.fromJson<String>(json['fromEntityId']),
      toEntityId: serializer.fromJson<String>(json['toEntityId']),
      relationType: serializer.fromJson<String>(json['relationType']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'fromEntityId': serializer.toJson<String>(fromEntityId),
      'toEntityId': serializer.toJson<String>(toEntityId),
      'relationType': serializer.toJson<String>(relationType),
    };
  }

  EntityRelation copyWith(
          {String? id,
          String? fromEntityId,
          String? toEntityId,
          String? relationType}) =>
      EntityRelation(
        id: id ?? this.id,
        fromEntityId: fromEntityId ?? this.fromEntityId,
        toEntityId: toEntityId ?? this.toEntityId,
        relationType: relationType ?? this.relationType,
      );
  EntityRelation copyWithCompanion(EntityRelationsCompanion data) {
    return EntityRelation(
      id: data.id.present ? data.id.value : this.id,
      fromEntityId: data.fromEntityId.present
          ? data.fromEntityId.value
          : this.fromEntityId,
      toEntityId:
          data.toEntityId.present ? data.toEntityId.value : this.toEntityId,
      relationType: data.relationType.present
          ? data.relationType.value
          : this.relationType,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EntityRelation(')
          ..write('id: $id, ')
          ..write('fromEntityId: $fromEntityId, ')
          ..write('toEntityId: $toEntityId, ')
          ..write('relationType: $relationType')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, fromEntityId, toEntityId, relationType);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EntityRelation &&
          other.id == this.id &&
          other.fromEntityId == this.fromEntityId &&
          other.toEntityId == this.toEntityId &&
          other.relationType == this.relationType);
}

class EntityRelationsCompanion extends UpdateCompanion<EntityRelation> {
  final Value<String> id;
  final Value<String> fromEntityId;
  final Value<String> toEntityId;
  final Value<String> relationType;
  final Value<int> rowid;
  const EntityRelationsCompanion({
    this.id = const Value.absent(),
    this.fromEntityId = const Value.absent(),
    this.toEntityId = const Value.absent(),
    this.relationType = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EntityRelationsCompanion.insert({
    required String id,
    required String fromEntityId,
    required String toEntityId,
    required String relationType,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        fromEntityId = Value(fromEntityId),
        toEntityId = Value(toEntityId),
        relationType = Value(relationType);
  static Insertable<EntityRelation> custom({
    Expression<String>? id,
    Expression<String>? fromEntityId,
    Expression<String>? toEntityId,
    Expression<String>? relationType,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fromEntityId != null) 'from_entity_id': fromEntityId,
      if (toEntityId != null) 'to_entity_id': toEntityId,
      if (relationType != null) 'relation_type': relationType,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EntityRelationsCompanion copyWith(
      {Value<String>? id,
      Value<String>? fromEntityId,
      Value<String>? toEntityId,
      Value<String>? relationType,
      Value<int>? rowid}) {
    return EntityRelationsCompanion(
      id: id ?? this.id,
      fromEntityId: fromEntityId ?? this.fromEntityId,
      toEntityId: toEntityId ?? this.toEntityId,
      relationType: relationType ?? this.relationType,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (fromEntityId.present) {
      map['from_entity_id'] = Variable<String>(fromEntityId.value);
    }
    if (toEntityId.present) {
      map['to_entity_id'] = Variable<String>(toEntityId.value);
    }
    if (relationType.present) {
      map['relation_type'] = Variable<String>(relationType.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EntityRelationsCompanion(')
          ..write('id: $id, ')
          ..write('fromEntityId: $fromEntityId, ')
          ..write('toEntityId: $toEntityId, ')
          ..write('relationType: $relationType, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TasksTable extends Tasks with TableInfo<$TasksTable, Task> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ownerIdMeta =
      const VerificationMeta('ownerId');
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
      'owner_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _endDateMeta =
      const VerificationMeta('endDate');
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
      'end_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _recurrenceRuleMeta =
      const VerificationMeta('recurrenceRule');
  @override
  late final GeneratedColumn<String> recurrenceRule = GeneratedColumn<String>(
      'recurrence_rule', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _reminderSettingsMeta =
      const VerificationMeta('reminderSettings');
  @override
  late final GeneratedColumn<String> reminderSettings = GeneratedColumn<String>(
      'reminder_settings', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _linkedEntityIdMeta =
      const VerificationMeta('linkedEntityId');
  @override
  late final GeneratedColumn<String> linkedEntityId = GeneratedColumn<String>(
      'linked_entity_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        ownerId,
        title,
        description,
        startDate,
        endDate,
        recurrenceRule,
        reminderSettings,
        status,
        linkedEntityId,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(Insertable<Task> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(_ownerIdMeta,
          ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta));
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    }
    if (data.containsKey('end_date')) {
      context.handle(_endDateMeta,
          endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta));
    }
    if (data.containsKey('recurrence_rule')) {
      context.handle(
          _recurrenceRuleMeta,
          recurrenceRule.isAcceptableOrUnknown(
              data['recurrence_rule']!, _recurrenceRuleMeta));
    }
    if (data.containsKey('reminder_settings')) {
      context.handle(
          _reminderSettingsMeta,
          reminderSettings.isAcceptableOrUnknown(
              data['reminder_settings']!, _reminderSettingsMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('linked_entity_id')) {
      context.handle(
          _linkedEntityIdMeta,
          linkedEntityId.isAcceptableOrUnknown(
              data['linked_entity_id']!, _linkedEntityIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Task map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Task(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      ownerId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}owner_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date']),
      endDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_date']),
      recurrenceRule: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}recurrence_rule']),
      reminderSettings: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}reminder_settings']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      linkedEntityId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}linked_entity_id']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(attachedDatabase, alias);
  }
}

class Task extends DataClass implements Insertable<Task> {
  final String id;
  final String ownerId;
  final String title;
  final String? description;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? recurrenceRule;
  final String? reminderSettings;
  final String status;
  final String? linkedEntityId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Task(
      {required this.id,
      required this.ownerId,
      required this.title,
      this.description,
      this.startDate,
      this.endDate,
      this.recurrenceRule,
      this.reminderSettings,
      required this.status,
      this.linkedEntityId,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['owner_id'] = Variable<String>(ownerId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || startDate != null) {
      map['start_date'] = Variable<DateTime>(startDate);
    }
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    if (!nullToAbsent || recurrenceRule != null) {
      map['recurrence_rule'] = Variable<String>(recurrenceRule);
    }
    if (!nullToAbsent || reminderSettings != null) {
      map['reminder_settings'] = Variable<String>(reminderSettings);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || linkedEntityId != null) {
      map['linked_entity_id'] = Variable<String>(linkedEntityId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: Value(id),
      ownerId: Value(ownerId),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      startDate: startDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      recurrenceRule: recurrenceRule == null && nullToAbsent
          ? const Value.absent()
          : Value(recurrenceRule),
      reminderSettings: reminderSettings == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderSettings),
      status: Value(status),
      linkedEntityId: linkedEntityId == null && nullToAbsent
          ? const Value.absent()
          : Value(linkedEntityId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Task.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Task(
      id: serializer.fromJson<String>(json['id']),
      ownerId: serializer.fromJson<String>(json['ownerId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      startDate: serializer.fromJson<DateTime?>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      recurrenceRule: serializer.fromJson<String?>(json['recurrenceRule']),
      reminderSettings: serializer.fromJson<String?>(json['reminderSettings']),
      status: serializer.fromJson<String>(json['status']),
      linkedEntityId: serializer.fromJson<String?>(json['linkedEntityId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ownerId': serializer.toJson<String>(ownerId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'startDate': serializer.toJson<DateTime?>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'recurrenceRule': serializer.toJson<String?>(recurrenceRule),
      'reminderSettings': serializer.toJson<String?>(reminderSettings),
      'status': serializer.toJson<String>(status),
      'linkedEntityId': serializer.toJson<String?>(linkedEntityId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Task copyWith(
          {String? id,
          String? ownerId,
          String? title,
          Value<String?> description = const Value.absent(),
          Value<DateTime?> startDate = const Value.absent(),
          Value<DateTime?> endDate = const Value.absent(),
          Value<String?> recurrenceRule = const Value.absent(),
          Value<String?> reminderSettings = const Value.absent(),
          String? status,
          Value<String?> linkedEntityId = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Task(
        id: id ?? this.id,
        ownerId: ownerId ?? this.ownerId,
        title: title ?? this.title,
        description: description.present ? description.value : this.description,
        startDate: startDate.present ? startDate.value : this.startDate,
        endDate: endDate.present ? endDate.value : this.endDate,
        recurrenceRule:
            recurrenceRule.present ? recurrenceRule.value : this.recurrenceRule,
        reminderSettings: reminderSettings.present
            ? reminderSettings.value
            : this.reminderSettings,
        status: status ?? this.status,
        linkedEntityId:
            linkedEntityId.present ? linkedEntityId.value : this.linkedEntityId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Task copyWithCompanion(TasksCompanion data) {
    return Task(
      id: data.id.present ? data.id.value : this.id,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      recurrenceRule: data.recurrenceRule.present
          ? data.recurrenceRule.value
          : this.recurrenceRule,
      reminderSettings: data.reminderSettings.present
          ? data.reminderSettings.value
          : this.reminderSettings,
      status: data.status.present ? data.status.value : this.status,
      linkedEntityId: data.linkedEntityId.present
          ? data.linkedEntityId.value
          : this.linkedEntityId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Task(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('recurrenceRule: $recurrenceRule, ')
          ..write('reminderSettings: $reminderSettings, ')
          ..write('status: $status, ')
          ..write('linkedEntityId: $linkedEntityId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      ownerId,
      title,
      description,
      startDate,
      endDate,
      recurrenceRule,
      reminderSettings,
      status,
      linkedEntityId,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Task &&
          other.id == this.id &&
          other.ownerId == this.ownerId &&
          other.title == this.title &&
          other.description == this.description &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.recurrenceRule == this.recurrenceRule &&
          other.reminderSettings == this.reminderSettings &&
          other.status == this.status &&
          other.linkedEntityId == this.linkedEntityId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TasksCompanion extends UpdateCompanion<Task> {
  final Value<String> id;
  final Value<String> ownerId;
  final Value<String> title;
  final Value<String?> description;
  final Value<DateTime?> startDate;
  final Value<DateTime?> endDate;
  final Value<String?> recurrenceRule;
  final Value<String?> reminderSettings;
  final Value<String> status;
  final Value<String?> linkedEntityId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.recurrenceRule = const Value.absent(),
    this.reminderSettings = const Value.absent(),
    this.status = const Value.absent(),
    this.linkedEntityId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TasksCompanion.insert({
    required String id,
    required String ownerId,
    required String title,
    this.description = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.recurrenceRule = const Value.absent(),
    this.reminderSettings = const Value.absent(),
    this.status = const Value.absent(),
    this.linkedEntityId = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        ownerId = Value(ownerId),
        title = Value(title),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Task> custom({
    Expression<String>? id,
    Expression<String>? ownerId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<String>? recurrenceRule,
    Expression<String>? reminderSettings,
    Expression<String>? status,
    Expression<String>? linkedEntityId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerId != null) 'owner_id': ownerId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (recurrenceRule != null) 'recurrence_rule': recurrenceRule,
      if (reminderSettings != null) 'reminder_settings': reminderSettings,
      if (status != null) 'status': status,
      if (linkedEntityId != null) 'linked_entity_id': linkedEntityId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TasksCompanion copyWith(
      {Value<String>? id,
      Value<String>? ownerId,
      Value<String>? title,
      Value<String?>? description,
      Value<DateTime?>? startDate,
      Value<DateTime?>? endDate,
      Value<String?>? recurrenceRule,
      Value<String?>? reminderSettings,
      Value<String>? status,
      Value<String?>? linkedEntityId,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return TasksCompanion(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      recurrenceRule: recurrenceRule ?? this.recurrenceRule,
      reminderSettings: reminderSettings ?? this.reminderSettings,
      status: status ?? this.status,
      linkedEntityId: linkedEntityId ?? this.linkedEntityId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (recurrenceRule.present) {
      map['recurrence_rule'] = Variable<String>(recurrenceRule.value);
    }
    if (reminderSettings.present) {
      map['reminder_settings'] = Variable<String>(reminderSettings.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (linkedEntityId.present) {
      map['linked_entity_id'] = Variable<String>(linkedEntityId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('recurrenceRule: $recurrenceRule, ')
          ..write('reminderSettings: $reminderSettings, ')
          ..write('status: $status, ')
          ..write('linkedEntityId: $linkedEntityId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $JournalEntriesTable extends JournalEntries
    with TableInfo<$JournalEntriesTable, JournalEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JournalEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ownerIdMeta =
      const VerificationMeta('ownerId');
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
      'owner_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _endDateMeta =
      const VerificationMeta('endDate');
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
      'end_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _recurrenceRuleMeta =
      const VerificationMeta('recurrenceRule');
  @override
  late final GeneratedColumn<String> recurrenceRule = GeneratedColumn<String>(
      'recurrence_rule', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _reminderSettingsMeta =
      const VerificationMeta('reminderSettings');
  @override
  late final GeneratedColumn<String> reminderSettings = GeneratedColumn<String>(
      'reminder_settings', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _linkedEntityIdMeta =
      const VerificationMeta('linkedEntityId');
  @override
  late final GeneratedColumn<String> linkedEntityId = GeneratedColumn<String>(
      'linked_entity_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        ownerId,
        content,
        startDate,
        endDate,
        recurrenceRule,
        reminderSettings,
        status,
        linkedEntityId,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journal_entries';
  @override
  VerificationContext validateIntegrity(Insertable<JournalEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(_ownerIdMeta,
          ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta));
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    }
    if (data.containsKey('end_date')) {
      context.handle(_endDateMeta,
          endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta));
    }
    if (data.containsKey('recurrence_rule')) {
      context.handle(
          _recurrenceRuleMeta,
          recurrenceRule.isAcceptableOrUnknown(
              data['recurrence_rule']!, _recurrenceRuleMeta));
    }
    if (data.containsKey('reminder_settings')) {
      context.handle(
          _reminderSettingsMeta,
          reminderSettings.isAcceptableOrUnknown(
              data['reminder_settings']!, _reminderSettingsMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('linked_entity_id')) {
      context.handle(
          _linkedEntityIdMeta,
          linkedEntityId.isAcceptableOrUnknown(
              data['linked_entity_id']!, _linkedEntityIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  JournalEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JournalEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      ownerId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}owner_id'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date']),
      endDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_date']),
      recurrenceRule: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}recurrence_rule']),
      reminderSettings: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}reminder_settings']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status']),
      linkedEntityId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}linked_entity_id']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $JournalEntriesTable createAlias(String alias) {
    return $JournalEntriesTable(attachedDatabase, alias);
  }
}

class JournalEntry extends DataClass implements Insertable<JournalEntry> {
  final String id;
  final String ownerId;
  final String content;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? recurrenceRule;
  final String? reminderSettings;
  final String? status;
  final String? linkedEntityId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const JournalEntry(
      {required this.id,
      required this.ownerId,
      required this.content,
      this.startDate,
      this.endDate,
      this.recurrenceRule,
      this.reminderSettings,
      this.status,
      this.linkedEntityId,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['owner_id'] = Variable<String>(ownerId);
    map['content'] = Variable<String>(content);
    if (!nullToAbsent || startDate != null) {
      map['start_date'] = Variable<DateTime>(startDate);
    }
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    if (!nullToAbsent || recurrenceRule != null) {
      map['recurrence_rule'] = Variable<String>(recurrenceRule);
    }
    if (!nullToAbsent || reminderSettings != null) {
      map['reminder_settings'] = Variable<String>(reminderSettings);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    if (!nullToAbsent || linkedEntityId != null) {
      map['linked_entity_id'] = Variable<String>(linkedEntityId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  JournalEntriesCompanion toCompanion(bool nullToAbsent) {
    return JournalEntriesCompanion(
      id: Value(id),
      ownerId: Value(ownerId),
      content: Value(content),
      startDate: startDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      recurrenceRule: recurrenceRule == null && nullToAbsent
          ? const Value.absent()
          : Value(recurrenceRule),
      reminderSettings: reminderSettings == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderSettings),
      status:
          status == null && nullToAbsent ? const Value.absent() : Value(status),
      linkedEntityId: linkedEntityId == null && nullToAbsent
          ? const Value.absent()
          : Value(linkedEntityId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory JournalEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JournalEntry(
      id: serializer.fromJson<String>(json['id']),
      ownerId: serializer.fromJson<String>(json['ownerId']),
      content: serializer.fromJson<String>(json['content']),
      startDate: serializer.fromJson<DateTime?>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      recurrenceRule: serializer.fromJson<String?>(json['recurrenceRule']),
      reminderSettings: serializer.fromJson<String?>(json['reminderSettings']),
      status: serializer.fromJson<String?>(json['status']),
      linkedEntityId: serializer.fromJson<String?>(json['linkedEntityId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ownerId': serializer.toJson<String>(ownerId),
      'content': serializer.toJson<String>(content),
      'startDate': serializer.toJson<DateTime?>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'recurrenceRule': serializer.toJson<String?>(recurrenceRule),
      'reminderSettings': serializer.toJson<String?>(reminderSettings),
      'status': serializer.toJson<String?>(status),
      'linkedEntityId': serializer.toJson<String?>(linkedEntityId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  JournalEntry copyWith(
          {String? id,
          String? ownerId,
          String? content,
          Value<DateTime?> startDate = const Value.absent(),
          Value<DateTime?> endDate = const Value.absent(),
          Value<String?> recurrenceRule = const Value.absent(),
          Value<String?> reminderSettings = const Value.absent(),
          Value<String?> status = const Value.absent(),
          Value<String?> linkedEntityId = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      JournalEntry(
        id: id ?? this.id,
        ownerId: ownerId ?? this.ownerId,
        content: content ?? this.content,
        startDate: startDate.present ? startDate.value : this.startDate,
        endDate: endDate.present ? endDate.value : this.endDate,
        recurrenceRule:
            recurrenceRule.present ? recurrenceRule.value : this.recurrenceRule,
        reminderSettings: reminderSettings.present
            ? reminderSettings.value
            : this.reminderSettings,
        status: status.present ? status.value : this.status,
        linkedEntityId:
            linkedEntityId.present ? linkedEntityId.value : this.linkedEntityId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  JournalEntry copyWithCompanion(JournalEntriesCompanion data) {
    return JournalEntry(
      id: data.id.present ? data.id.value : this.id,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      content: data.content.present ? data.content.value : this.content,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      recurrenceRule: data.recurrenceRule.present
          ? data.recurrenceRule.value
          : this.recurrenceRule,
      reminderSettings: data.reminderSettings.present
          ? data.reminderSettings.value
          : this.reminderSettings,
      status: data.status.present ? data.status.value : this.status,
      linkedEntityId: data.linkedEntityId.present
          ? data.linkedEntityId.value
          : this.linkedEntityId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JournalEntry(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('content: $content, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('recurrenceRule: $recurrenceRule, ')
          ..write('reminderSettings: $reminderSettings, ')
          ..write('status: $status, ')
          ..write('linkedEntityId: $linkedEntityId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      ownerId,
      content,
      startDate,
      endDate,
      recurrenceRule,
      reminderSettings,
      status,
      linkedEntityId,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JournalEntry &&
          other.id == this.id &&
          other.ownerId == this.ownerId &&
          other.content == this.content &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.recurrenceRule == this.recurrenceRule &&
          other.reminderSettings == this.reminderSettings &&
          other.status == this.status &&
          other.linkedEntityId == this.linkedEntityId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class JournalEntriesCompanion extends UpdateCompanion<JournalEntry> {
  final Value<String> id;
  final Value<String> ownerId;
  final Value<String> content;
  final Value<DateTime?> startDate;
  final Value<DateTime?> endDate;
  final Value<String?> recurrenceRule;
  final Value<String?> reminderSettings;
  final Value<String?> status;
  final Value<String?> linkedEntityId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const JournalEntriesCompanion({
    this.id = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.content = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.recurrenceRule = const Value.absent(),
    this.reminderSettings = const Value.absent(),
    this.status = const Value.absent(),
    this.linkedEntityId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  JournalEntriesCompanion.insert({
    required String id,
    required String ownerId,
    required String content,
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.recurrenceRule = const Value.absent(),
    this.reminderSettings = const Value.absent(),
    this.status = const Value.absent(),
    this.linkedEntityId = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        ownerId = Value(ownerId),
        content = Value(content),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<JournalEntry> custom({
    Expression<String>? id,
    Expression<String>? ownerId,
    Expression<String>? content,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<String>? recurrenceRule,
    Expression<String>? reminderSettings,
    Expression<String>? status,
    Expression<String>? linkedEntityId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerId != null) 'owner_id': ownerId,
      if (content != null) 'content': content,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (recurrenceRule != null) 'recurrence_rule': recurrenceRule,
      if (reminderSettings != null) 'reminder_settings': reminderSettings,
      if (status != null) 'status': status,
      if (linkedEntityId != null) 'linked_entity_id': linkedEntityId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  JournalEntriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? ownerId,
      Value<String>? content,
      Value<DateTime?>? startDate,
      Value<DateTime?>? endDate,
      Value<String?>? recurrenceRule,
      Value<String?>? reminderSettings,
      Value<String?>? status,
      Value<String?>? linkedEntityId,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return JournalEntriesCompanion(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      content: content ?? this.content,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      recurrenceRule: recurrenceRule ?? this.recurrenceRule,
      reminderSettings: reminderSettings ?? this.reminderSettings,
      status: status ?? this.status,
      linkedEntityId: linkedEntityId ?? this.linkedEntityId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (recurrenceRule.present) {
      map['recurrence_rule'] = Variable<String>(recurrenceRule.value);
    }
    if (reminderSettings.present) {
      map['reminder_settings'] = Variable<String>(reminderSettings.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (linkedEntityId.present) {
      map['linked_entity_id'] = Variable<String>(linkedEntityId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JournalEntriesCompanion(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('content: $content, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('recurrenceRule: $recurrenceRule, ')
          ..write('reminderSettings: $reminderSettings, ')
          ..write('status: $status, ')
          ..write('linkedEntityId: $linkedEntityId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HabitsTable extends Habits with TableInfo<$HabitsTable, Habit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ownerIdMeta =
      const VerificationMeta('ownerId');
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
      'owner_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _completedTodayMeta =
      const VerificationMeta('completedToday');
  @override
  late final GeneratedColumn<bool> completedToday = GeneratedColumn<bool>(
      'completed_today', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("completed_today" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [id, ownerId, name, completedToday];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habits';
  @override
  VerificationContext validateIntegrity(Insertable<Habit> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(_ownerIdMeta,
          ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta));
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('completed_today')) {
      context.handle(
          _completedTodayMeta,
          completedToday.isAcceptableOrUnknown(
              data['completed_today']!, _completedTodayMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Habit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Habit(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      ownerId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}owner_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      completedToday: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}completed_today'])!,
    );
  }

  @override
  $HabitsTable createAlias(String alias) {
    return $HabitsTable(attachedDatabase, alias);
  }
}

class Habit extends DataClass implements Insertable<Habit> {
  final String id;
  final String ownerId;
  final String name;
  final bool completedToday;
  const Habit(
      {required this.id,
      required this.ownerId,
      required this.name,
      required this.completedToday});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['owner_id'] = Variable<String>(ownerId);
    map['name'] = Variable<String>(name);
    map['completed_today'] = Variable<bool>(completedToday);
    return map;
  }

  HabitsCompanion toCompanion(bool nullToAbsent) {
    return HabitsCompanion(
      id: Value(id),
      ownerId: Value(ownerId),
      name: Value(name),
      completedToday: Value(completedToday),
    );
  }

  factory Habit.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Habit(
      id: serializer.fromJson<String>(json['id']),
      ownerId: serializer.fromJson<String>(json['ownerId']),
      name: serializer.fromJson<String>(json['name']),
      completedToday: serializer.fromJson<bool>(json['completedToday']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ownerId': serializer.toJson<String>(ownerId),
      'name': serializer.toJson<String>(name),
      'completedToday': serializer.toJson<bool>(completedToday),
    };
  }

  Habit copyWith(
          {String? id, String? ownerId, String? name, bool? completedToday}) =>
      Habit(
        id: id ?? this.id,
        ownerId: ownerId ?? this.ownerId,
        name: name ?? this.name,
        completedToday: completedToday ?? this.completedToday,
      );
  Habit copyWithCompanion(HabitsCompanion data) {
    return Habit(
      id: data.id.present ? data.id.value : this.id,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      name: data.name.present ? data.name.value : this.name,
      completedToday: data.completedToday.present
          ? data.completedToday.value
          : this.completedToday,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Habit(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('name: $name, ')
          ..write('completedToday: $completedToday')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, ownerId, name, completedToday);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Habit &&
          other.id == this.id &&
          other.ownerId == this.ownerId &&
          other.name == this.name &&
          other.completedToday == this.completedToday);
}

class HabitsCompanion extends UpdateCompanion<Habit> {
  final Value<String> id;
  final Value<String> ownerId;
  final Value<String> name;
  final Value<bool> completedToday;
  final Value<int> rowid;
  const HabitsCompanion({
    this.id = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.name = const Value.absent(),
    this.completedToday = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HabitsCompanion.insert({
    required String id,
    required String ownerId,
    required String name,
    this.completedToday = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        ownerId = Value(ownerId),
        name = Value(name);
  static Insertable<Habit> custom({
    Expression<String>? id,
    Expression<String>? ownerId,
    Expression<String>? name,
    Expression<bool>? completedToday,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerId != null) 'owner_id': ownerId,
      if (name != null) 'name': name,
      if (completedToday != null) 'completed_today': completedToday,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HabitsCompanion copyWith(
      {Value<String>? id,
      Value<String>? ownerId,
      Value<String>? name,
      Value<bool>? completedToday,
      Value<int>? rowid}) {
    return HabitsCompanion(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      completedToday: completedToday ?? this.completedToday,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (completedToday.present) {
      map['completed_today'] = Variable<bool>(completedToday.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitsCompanion(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('name: $name, ')
          ..write('completedToday: $completedToday, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProjectsTable extends Projects with TableInfo<$ProjectsTable, Project> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ownerIdMeta =
      const VerificationMeta('ownerId');
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
      'owner_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, ownerId, title, status];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'projects';
  @override
  VerificationContext validateIntegrity(Insertable<Project> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(_ownerIdMeta,
          ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta));
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Project map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Project(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      ownerId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}owner_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status']),
    );
  }

  @override
  $ProjectsTable createAlias(String alias) {
    return $ProjectsTable(attachedDatabase, alias);
  }
}

class Project extends DataClass implements Insertable<Project> {
  final String id;
  final String ownerId;
  final String title;
  final String? status;
  const Project(
      {required this.id,
      required this.ownerId,
      required this.title,
      this.status});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['owner_id'] = Variable<String>(ownerId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    return map;
  }

  ProjectsCompanion toCompanion(bool nullToAbsent) {
    return ProjectsCompanion(
      id: Value(id),
      ownerId: Value(ownerId),
      title: Value(title),
      status:
          status == null && nullToAbsent ? const Value.absent() : Value(status),
    );
  }

  factory Project.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Project(
      id: serializer.fromJson<String>(json['id']),
      ownerId: serializer.fromJson<String>(json['ownerId']),
      title: serializer.fromJson<String>(json['title']),
      status: serializer.fromJson<String?>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ownerId': serializer.toJson<String>(ownerId),
      'title': serializer.toJson<String>(title),
      'status': serializer.toJson<String?>(status),
    };
  }

  Project copyWith(
          {String? id,
          String? ownerId,
          String? title,
          Value<String?> status = const Value.absent()}) =>
      Project(
        id: id ?? this.id,
        ownerId: ownerId ?? this.ownerId,
        title: title ?? this.title,
        status: status.present ? status.value : this.status,
      );
  Project copyWithCompanion(ProjectsCompanion data) {
    return Project(
      id: data.id.present ? data.id.value : this.id,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      title: data.title.present ? data.title.value : this.title,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Project(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('title: $title, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, ownerId, title, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Project &&
          other.id == this.id &&
          other.ownerId == this.ownerId &&
          other.title == this.title &&
          other.status == this.status);
}

class ProjectsCompanion extends UpdateCompanion<Project> {
  final Value<String> id;
  final Value<String> ownerId;
  final Value<String> title;
  final Value<String?> status;
  final Value<int> rowid;
  const ProjectsCompanion({
    this.id = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.title = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProjectsCompanion.insert({
    required String id,
    required String ownerId,
    required String title,
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        ownerId = Value(ownerId),
        title = Value(title);
  static Insertable<Project> custom({
    Expression<String>? id,
    Expression<String>? ownerId,
    Expression<String>? title,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerId != null) 'owner_id': ownerId,
      if (title != null) 'title': title,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProjectsCompanion copyWith(
      {Value<String>? id,
      Value<String>? ownerId,
      Value<String>? title,
      Value<String?>? status,
      Value<int>? rowid}) {
    return ProjectsCompanion(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      title: title ?? this.title,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectsCompanion(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('title: $title, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FinanceRecordsTable extends FinanceRecords
    with TableInfo<$FinanceRecordsTable, FinanceRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FinanceRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ownerIdMeta =
      const VerificationMeta('ownerId');
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
      'owner_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, ownerId, amount, category, date];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'finance_records';
  @override
  VerificationContext validateIntegrity(Insertable<FinanceRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(_ownerIdMeta,
          ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta));
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FinanceRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FinanceRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      ownerId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}owner_id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category']),
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
    );
  }

  @override
  $FinanceRecordsTable createAlias(String alias) {
    return $FinanceRecordsTable(attachedDatabase, alias);
  }
}

class FinanceRecord extends DataClass implements Insertable<FinanceRecord> {
  final String id;
  final String ownerId;
  final double amount;
  final String? category;
  final DateTime date;
  const FinanceRecord(
      {required this.id,
      required this.ownerId,
      required this.amount,
      this.category,
      required this.date});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['owner_id'] = Variable<String>(ownerId);
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    map['date'] = Variable<DateTime>(date);
    return map;
  }

  FinanceRecordsCompanion toCompanion(bool nullToAbsent) {
    return FinanceRecordsCompanion(
      id: Value(id),
      ownerId: Value(ownerId),
      amount: Value(amount),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      date: Value(date),
    );
  }

  factory FinanceRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FinanceRecord(
      id: serializer.fromJson<String>(json['id']),
      ownerId: serializer.fromJson<String>(json['ownerId']),
      amount: serializer.fromJson<double>(json['amount']),
      category: serializer.fromJson<String?>(json['category']),
      date: serializer.fromJson<DateTime>(json['date']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ownerId': serializer.toJson<String>(ownerId),
      'amount': serializer.toJson<double>(amount),
      'category': serializer.toJson<String?>(category),
      'date': serializer.toJson<DateTime>(date),
    };
  }

  FinanceRecord copyWith(
          {String? id,
          String? ownerId,
          double? amount,
          Value<String?> category = const Value.absent(),
          DateTime? date}) =>
      FinanceRecord(
        id: id ?? this.id,
        ownerId: ownerId ?? this.ownerId,
        amount: amount ?? this.amount,
        category: category.present ? category.value : this.category,
        date: date ?? this.date,
      );
  FinanceRecord copyWithCompanion(FinanceRecordsCompanion data) {
    return FinanceRecord(
      id: data.id.present ? data.id.value : this.id,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      amount: data.amount.present ? data.amount.value : this.amount,
      category: data.category.present ? data.category.value : this.category,
      date: data.date.present ? data.date.value : this.date,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FinanceRecord(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('amount: $amount, ')
          ..write('category: $category, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, ownerId, amount, category, date);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FinanceRecord &&
          other.id == this.id &&
          other.ownerId == this.ownerId &&
          other.amount == this.amount &&
          other.category == this.category &&
          other.date == this.date);
}

class FinanceRecordsCompanion extends UpdateCompanion<FinanceRecord> {
  final Value<String> id;
  final Value<String> ownerId;
  final Value<double> amount;
  final Value<String?> category;
  final Value<DateTime> date;
  final Value<int> rowid;
  const FinanceRecordsCompanion({
    this.id = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.amount = const Value.absent(),
    this.category = const Value.absent(),
    this.date = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FinanceRecordsCompanion.insert({
    required String id,
    required String ownerId,
    required double amount,
    this.category = const Value.absent(),
    required DateTime date,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        ownerId = Value(ownerId),
        amount = Value(amount),
        date = Value(date);
  static Insertable<FinanceRecord> custom({
    Expression<String>? id,
    Expression<String>? ownerId,
    Expression<double>? amount,
    Expression<String>? category,
    Expression<DateTime>? date,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerId != null) 'owner_id': ownerId,
      if (amount != null) 'amount': amount,
      if (category != null) 'category': category,
      if (date != null) 'date': date,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FinanceRecordsCompanion copyWith(
      {Value<String>? id,
      Value<String>? ownerId,
      Value<double>? amount,
      Value<String?>? category,
      Value<DateTime>? date,
      Value<int>? rowid}) {
    return FinanceRecordsCompanion(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FinanceRecordsCompanion(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('amount: $amount, ')
          ..write('category: $category, ')
          ..write('date: $date, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HealthRecordsTable extends HealthRecords
    with TableInfo<$HealthRecordsTable, HealthRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HealthRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ownerIdMeta =
      const VerificationMeta('ownerId');
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
      'owner_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, ownerId, type, value, date];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'health_records';
  @override
  VerificationContext validateIntegrity(Insertable<HealthRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(_ownerIdMeta,
          ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta));
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HealthRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HealthRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      ownerId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}owner_id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value']),
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
    );
  }

  @override
  $HealthRecordsTable createAlias(String alias) {
    return $HealthRecordsTable(attachedDatabase, alias);
  }
}

class HealthRecord extends DataClass implements Insertable<HealthRecord> {
  final String id;
  final String ownerId;
  final String type;
  final String? value;
  final DateTime date;
  const HealthRecord(
      {required this.id,
      required this.ownerId,
      required this.type,
      this.value,
      required this.date});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['owner_id'] = Variable<String>(ownerId);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || value != null) {
      map['value'] = Variable<String>(value);
    }
    map['date'] = Variable<DateTime>(date);
    return map;
  }

  HealthRecordsCompanion toCompanion(bool nullToAbsent) {
    return HealthRecordsCompanion(
      id: Value(id),
      ownerId: Value(ownerId),
      type: Value(type),
      value:
          value == null && nullToAbsent ? const Value.absent() : Value(value),
      date: Value(date),
    );
  }

  factory HealthRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HealthRecord(
      id: serializer.fromJson<String>(json['id']),
      ownerId: serializer.fromJson<String>(json['ownerId']),
      type: serializer.fromJson<String>(json['type']),
      value: serializer.fromJson<String?>(json['value']),
      date: serializer.fromJson<DateTime>(json['date']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ownerId': serializer.toJson<String>(ownerId),
      'type': serializer.toJson<String>(type),
      'value': serializer.toJson<String?>(value),
      'date': serializer.toJson<DateTime>(date),
    };
  }

  HealthRecord copyWith(
          {String? id,
          String? ownerId,
          String? type,
          Value<String?> value = const Value.absent(),
          DateTime? date}) =>
      HealthRecord(
        id: id ?? this.id,
        ownerId: ownerId ?? this.ownerId,
        type: type ?? this.type,
        value: value.present ? value.value : this.value,
        date: date ?? this.date,
      );
  HealthRecord copyWithCompanion(HealthRecordsCompanion data) {
    return HealthRecord(
      id: data.id.present ? data.id.value : this.id,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      type: data.type.present ? data.type.value : this.type,
      value: data.value.present ? data.value.value : this.value,
      date: data.date.present ? data.date.value : this.date,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HealthRecord(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('type: $type, ')
          ..write('value: $value, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, ownerId, type, value, date);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HealthRecord &&
          other.id == this.id &&
          other.ownerId == this.ownerId &&
          other.type == this.type &&
          other.value == this.value &&
          other.date == this.date);
}

class HealthRecordsCompanion extends UpdateCompanion<HealthRecord> {
  final Value<String> id;
  final Value<String> ownerId;
  final Value<String> type;
  final Value<String?> value;
  final Value<DateTime> date;
  final Value<int> rowid;
  const HealthRecordsCompanion({
    this.id = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.type = const Value.absent(),
    this.value = const Value.absent(),
    this.date = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HealthRecordsCompanion.insert({
    required String id,
    required String ownerId,
    required String type,
    this.value = const Value.absent(),
    required DateTime date,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        ownerId = Value(ownerId),
        type = Value(type),
        date = Value(date);
  static Insertable<HealthRecord> custom({
    Expression<String>? id,
    Expression<String>? ownerId,
    Expression<String>? type,
    Expression<String>? value,
    Expression<DateTime>? date,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerId != null) 'owner_id': ownerId,
      if (type != null) 'type': type,
      if (value != null) 'value': value,
      if (date != null) 'date': date,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HealthRecordsCompanion copyWith(
      {Value<String>? id,
      Value<String>? ownerId,
      Value<String>? type,
      Value<String?>? value,
      Value<DateTime>? date,
      Value<int>? rowid}) {
    return HealthRecordsCompanion(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      type: type ?? this.type,
      value: value ?? this.value,
      date: date ?? this.date,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HealthRecordsCompanion(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('type: $type, ')
          ..write('value: $value, ')
          ..write('date: $date, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MenstruationCyclesTable extends MenstruationCycles
    with TableInfo<$MenstruationCyclesTable, MenstruationCycle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MenstruationCyclesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ownerIdMeta =
      const VerificationMeta('ownerId');
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
      'owner_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endDateMeta =
      const VerificationMeta('endDate');
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
      'end_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, ownerId, startDate, endDate];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'menstruation_cycles';
  @override
  VerificationContext validateIntegrity(Insertable<MenstruationCycle> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(_ownerIdMeta,
          ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta));
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(_endDateMeta,
          endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MenstruationCycle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MenstruationCycle(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      ownerId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}owner_id'])!,
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date'])!,
      endDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_date']),
    );
  }

  @override
  $MenstruationCyclesTable createAlias(String alias) {
    return $MenstruationCyclesTable(attachedDatabase, alias);
  }
}

class MenstruationCycle extends DataClass
    implements Insertable<MenstruationCycle> {
  final String id;
  final String ownerId;
  final DateTime startDate;
  final DateTime? endDate;
  const MenstruationCycle(
      {required this.id,
      required this.ownerId,
      required this.startDate,
      this.endDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['owner_id'] = Variable<String>(ownerId);
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    return map;
  }

  MenstruationCyclesCompanion toCompanion(bool nullToAbsent) {
    return MenstruationCyclesCompanion(
      id: Value(id),
      ownerId: Value(ownerId),
      startDate: Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
    );
  }

  factory MenstruationCycle.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MenstruationCycle(
      id: serializer.fromJson<String>(json['id']),
      ownerId: serializer.fromJson<String>(json['ownerId']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ownerId': serializer.toJson<String>(ownerId),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
    };
  }

  MenstruationCycle copyWith(
          {String? id,
          String? ownerId,
          DateTime? startDate,
          Value<DateTime?> endDate = const Value.absent()}) =>
      MenstruationCycle(
        id: id ?? this.id,
        ownerId: ownerId ?? this.ownerId,
        startDate: startDate ?? this.startDate,
        endDate: endDate.present ? endDate.value : this.endDate,
      );
  MenstruationCycle copyWithCompanion(MenstruationCyclesCompanion data) {
    return MenstruationCycle(
      id: data.id.present ? data.id.value : this.id,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MenstruationCycle(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, ownerId, startDate, endDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MenstruationCycle &&
          other.id == this.id &&
          other.ownerId == this.ownerId &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate);
}

class MenstruationCyclesCompanion extends UpdateCompanion<MenstruationCycle> {
  final Value<String> id;
  final Value<String> ownerId;
  final Value<DateTime> startDate;
  final Value<DateTime?> endDate;
  final Value<int> rowid;
  const MenstruationCyclesCompanion({
    this.id = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MenstruationCyclesCompanion.insert({
    required String id,
    required String ownerId,
    required DateTime startDate,
    this.endDate = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        ownerId = Value(ownerId),
        startDate = Value(startDate);
  static Insertable<MenstruationCycle> custom({
    Expression<String>? id,
    Expression<String>? ownerId,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerId != null) 'owner_id': ownerId,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MenstruationCyclesCompanion copyWith(
      {Value<String>? id,
      Value<String>? ownerId,
      Value<DateTime>? startDate,
      Value<DateTime?>? endDate,
      Value<int>? rowid}) {
    return MenstruationCyclesCompanion(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MenstruationCyclesCompanion(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NutritionEntriesTable extends NutritionEntries
    with TableInfo<$NutritionEntriesTable, NutritionEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NutritionEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ownerIdMeta =
      const VerificationMeta('ownerId');
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
      'owner_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _mealMeta = const VerificationMeta('meal');
  @override
  late final GeneratedColumn<String> meal = GeneratedColumn<String>(
      'meal', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, ownerId, meal, notes, date];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'nutrition_entries';
  @override
  VerificationContext validateIntegrity(Insertable<NutritionEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(_ownerIdMeta,
          ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta));
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('meal')) {
      context.handle(
          _mealMeta, meal.isAcceptableOrUnknown(data['meal']!, _mealMeta));
    } else if (isInserting) {
      context.missing(_mealMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NutritionEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NutritionEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      ownerId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}owner_id'])!,
      meal: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}meal'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
    );
  }

  @override
  $NutritionEntriesTable createAlias(String alias) {
    return $NutritionEntriesTable(attachedDatabase, alias);
  }
}

class NutritionEntry extends DataClass implements Insertable<NutritionEntry> {
  final String id;
  final String ownerId;
  final String meal;
  final String? notes;
  final DateTime date;
  const NutritionEntry(
      {required this.id,
      required this.ownerId,
      required this.meal,
      this.notes,
      required this.date});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['owner_id'] = Variable<String>(ownerId);
    map['meal'] = Variable<String>(meal);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['date'] = Variable<DateTime>(date);
    return map;
  }

  NutritionEntriesCompanion toCompanion(bool nullToAbsent) {
    return NutritionEntriesCompanion(
      id: Value(id),
      ownerId: Value(ownerId),
      meal: Value(meal),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      date: Value(date),
    );
  }

  factory NutritionEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NutritionEntry(
      id: serializer.fromJson<String>(json['id']),
      ownerId: serializer.fromJson<String>(json['ownerId']),
      meal: serializer.fromJson<String>(json['meal']),
      notes: serializer.fromJson<String?>(json['notes']),
      date: serializer.fromJson<DateTime>(json['date']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ownerId': serializer.toJson<String>(ownerId),
      'meal': serializer.toJson<String>(meal),
      'notes': serializer.toJson<String?>(notes),
      'date': serializer.toJson<DateTime>(date),
    };
  }

  NutritionEntry copyWith(
          {String? id,
          String? ownerId,
          String? meal,
          Value<String?> notes = const Value.absent(),
          DateTime? date}) =>
      NutritionEntry(
        id: id ?? this.id,
        ownerId: ownerId ?? this.ownerId,
        meal: meal ?? this.meal,
        notes: notes.present ? notes.value : this.notes,
        date: date ?? this.date,
      );
  NutritionEntry copyWithCompanion(NutritionEntriesCompanion data) {
    return NutritionEntry(
      id: data.id.present ? data.id.value : this.id,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      meal: data.meal.present ? data.meal.value : this.meal,
      notes: data.notes.present ? data.notes.value : this.notes,
      date: data.date.present ? data.date.value : this.date,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NutritionEntry(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('meal: $meal, ')
          ..write('notes: $notes, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, ownerId, meal, notes, date);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NutritionEntry &&
          other.id == this.id &&
          other.ownerId == this.ownerId &&
          other.meal == this.meal &&
          other.notes == this.notes &&
          other.date == this.date);
}

class NutritionEntriesCompanion extends UpdateCompanion<NutritionEntry> {
  final Value<String> id;
  final Value<String> ownerId;
  final Value<String> meal;
  final Value<String?> notes;
  final Value<DateTime> date;
  final Value<int> rowid;
  const NutritionEntriesCompanion({
    this.id = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.meal = const Value.absent(),
    this.notes = const Value.absent(),
    this.date = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NutritionEntriesCompanion.insert({
    required String id,
    required String ownerId,
    required String meal,
    this.notes = const Value.absent(),
    required DateTime date,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        ownerId = Value(ownerId),
        meal = Value(meal),
        date = Value(date);
  static Insertable<NutritionEntry> custom({
    Expression<String>? id,
    Expression<String>? ownerId,
    Expression<String>? meal,
    Expression<String>? notes,
    Expression<DateTime>? date,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerId != null) 'owner_id': ownerId,
      if (meal != null) 'meal': meal,
      if (notes != null) 'notes': notes,
      if (date != null) 'date': date,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NutritionEntriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? ownerId,
      Value<String>? meal,
      Value<String?>? notes,
      Value<DateTime>? date,
      Value<int>? rowid}) {
    return NutritionEntriesCompanion(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      meal: meal ?? this.meal,
      notes: notes ?? this.notes,
      date: date ?? this.date,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (meal.present) {
      map['meal'] = Variable<String>(meal.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NutritionEntriesCompanion(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('meal: $meal, ')
          ..write('notes: $notes, ')
          ..write('date: $date, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $ModulesTable modules = $ModulesTable(this);
  late final $FeatureTogglesTable featureToggles = $FeatureTogglesTable(this);
  late final $PresetsTable presets = $PresetsTable(this);
  late final $EntityRelationsTable entityRelations =
      $EntityRelationsTable(this);
  late final $TasksTable tasks = $TasksTable(this);
  late final $JournalEntriesTable journalEntries = $JournalEntriesTable(this);
  late final $HabitsTable habits = $HabitsTable(this);
  late final $ProjectsTable projects = $ProjectsTable(this);
  late final $FinanceRecordsTable financeRecords = $FinanceRecordsTable(this);
  late final $HealthRecordsTable healthRecords = $HealthRecordsTable(this);
  late final $MenstruationCyclesTable menstruationCycles =
      $MenstruationCyclesTable(this);
  late final $NutritionEntriesTable nutritionEntries =
      $NutritionEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        users,
        modules,
        featureToggles,
        presets,
        entityRelations,
        tasks,
        journalEntries,
        habits,
        projects,
        financeRecords,
        healthRecords,
        menstruationCycles,
        nutritionEntries
      ];
}

typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  required String id,
  required String username,
  required String passwordHash,
  Value<String> authProvider,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<String> id,
  Value<String> username,
  Value<String> passwordHash,
  Value<String> authProvider,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get passwordHash => $composableBuilder(
      column: $table.passwordHash, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get authProvider => $composableBuilder(
      column: $table.authProvider, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get passwordHash => $composableBuilder(
      column: $table.passwordHash,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get authProvider => $composableBuilder(
      column: $table.authProvider,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get passwordHash => $composableBuilder(
      column: $table.passwordHash, builder: (column) => column);

  GeneratedColumn<String> get authProvider => $composableBuilder(
      column: $table.authProvider, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$UsersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
    User,
    PrefetchHooks Function()> {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> username = const Value.absent(),
            Value<String> passwordHash = const Value.absent(),
            Value<String> authProvider = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UsersCompanion(
            id: id,
            username: username,
            passwordHash: passwordHash,
            authProvider: authProvider,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String username,
            required String passwordHash,
            Value<String> authProvider = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              UsersCompanion.insert(
            id: id,
            username: username,
            passwordHash: passwordHash,
            authProvider: authProvider,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UsersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
    User,
    PrefetchHooks Function()>;
typedef $$ModulesTableCreateCompanionBuilder = ModulesCompanion Function({
  required String id,
  required String name,
  Value<bool> enabled,
  Value<bool> devOnly,
  Value<String?> configurableFeatures,
  Value<int> rowid,
});
typedef $$ModulesTableUpdateCompanionBuilder = ModulesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<bool> enabled,
  Value<bool> devOnly,
  Value<String?> configurableFeatures,
  Value<int> rowid,
});

class $$ModulesTableFilterComposer
    extends Composer<_$AppDatabase, $ModulesTable> {
  $$ModulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get enabled => $composableBuilder(
      column: $table.enabled, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get devOnly => $composableBuilder(
      column: $table.devOnly, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get configurableFeatures => $composableBuilder(
      column: $table.configurableFeatures,
      builder: (column) => ColumnFilters(column));
}

class $$ModulesTableOrderingComposer
    extends Composer<_$AppDatabase, $ModulesTable> {
  $$ModulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get enabled => $composableBuilder(
      column: $table.enabled, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get devOnly => $composableBuilder(
      column: $table.devOnly, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get configurableFeatures => $composableBuilder(
      column: $table.configurableFeatures,
      builder: (column) => ColumnOrderings(column));
}

class $$ModulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ModulesTable> {
  $$ModulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<bool> get devOnly =>
      $composableBuilder(column: $table.devOnly, builder: (column) => column);

  GeneratedColumn<String> get configurableFeatures => $composableBuilder(
      column: $table.configurableFeatures, builder: (column) => column);
}

class $$ModulesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ModulesTable,
    Module,
    $$ModulesTableFilterComposer,
    $$ModulesTableOrderingComposer,
    $$ModulesTableAnnotationComposer,
    $$ModulesTableCreateCompanionBuilder,
    $$ModulesTableUpdateCompanionBuilder,
    (Module, BaseReferences<_$AppDatabase, $ModulesTable, Module>),
    Module,
    PrefetchHooks Function()> {
  $$ModulesTableTableManager(_$AppDatabase db, $ModulesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ModulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ModulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ModulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<bool> enabled = const Value.absent(),
            Value<bool> devOnly = const Value.absent(),
            Value<String?> configurableFeatures = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ModulesCompanion(
            id: id,
            name: name,
            enabled: enabled,
            devOnly: devOnly,
            configurableFeatures: configurableFeatures,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<bool> enabled = const Value.absent(),
            Value<bool> devOnly = const Value.absent(),
            Value<String?> configurableFeatures = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ModulesCompanion.insert(
            id: id,
            name: name,
            enabled: enabled,
            devOnly: devOnly,
            configurableFeatures: configurableFeatures,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ModulesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ModulesTable,
    Module,
    $$ModulesTableFilterComposer,
    $$ModulesTableOrderingComposer,
    $$ModulesTableAnnotationComposer,
    $$ModulesTableCreateCompanionBuilder,
    $$ModulesTableUpdateCompanionBuilder,
    (Module, BaseReferences<_$AppDatabase, $ModulesTable, Module>),
    Module,
    PrefetchHooks Function()>;
typedef $$FeatureTogglesTableCreateCompanionBuilder = FeatureTogglesCompanion
    Function({
  required String id,
  required String moduleId,
  required String name,
  Value<bool> enabled,
  Value<int> rowid,
});
typedef $$FeatureTogglesTableUpdateCompanionBuilder = FeatureTogglesCompanion
    Function({
  Value<String> id,
  Value<String> moduleId,
  Value<String> name,
  Value<bool> enabled,
  Value<int> rowid,
});

class $$FeatureTogglesTableFilterComposer
    extends Composer<_$AppDatabase, $FeatureTogglesTable> {
  $$FeatureTogglesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get moduleId => $composableBuilder(
      column: $table.moduleId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get enabled => $composableBuilder(
      column: $table.enabled, builder: (column) => ColumnFilters(column));
}

class $$FeatureTogglesTableOrderingComposer
    extends Composer<_$AppDatabase, $FeatureTogglesTable> {
  $$FeatureTogglesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get moduleId => $composableBuilder(
      column: $table.moduleId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get enabled => $composableBuilder(
      column: $table.enabled, builder: (column) => ColumnOrderings(column));
}

class $$FeatureTogglesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FeatureTogglesTable> {
  $$FeatureTogglesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get moduleId =>
      $composableBuilder(column: $table.moduleId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);
}

class $$FeatureTogglesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FeatureTogglesTable,
    FeatureToggle,
    $$FeatureTogglesTableFilterComposer,
    $$FeatureTogglesTableOrderingComposer,
    $$FeatureTogglesTableAnnotationComposer,
    $$FeatureTogglesTableCreateCompanionBuilder,
    $$FeatureTogglesTableUpdateCompanionBuilder,
    (
      FeatureToggle,
      BaseReferences<_$AppDatabase, $FeatureTogglesTable, FeatureToggle>
    ),
    FeatureToggle,
    PrefetchHooks Function()> {
  $$FeatureTogglesTableTableManager(
      _$AppDatabase db, $FeatureTogglesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FeatureTogglesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FeatureTogglesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FeatureTogglesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> moduleId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<bool> enabled = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FeatureTogglesCompanion(
            id: id,
            moduleId: moduleId,
            name: name,
            enabled: enabled,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String moduleId,
            required String name,
            Value<bool> enabled = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FeatureTogglesCompanion.insert(
            id: id,
            moduleId: moduleId,
            name: name,
            enabled: enabled,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FeatureTogglesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FeatureTogglesTable,
    FeatureToggle,
    $$FeatureTogglesTableFilterComposer,
    $$FeatureTogglesTableOrderingComposer,
    $$FeatureTogglesTableAnnotationComposer,
    $$FeatureTogglesTableCreateCompanionBuilder,
    $$FeatureTogglesTableUpdateCompanionBuilder,
    (
      FeatureToggle,
      BaseReferences<_$AppDatabase, $FeatureTogglesTable, FeatureToggle>
    ),
    FeatureToggle,
    PrefetchHooks Function()>;
typedef $$PresetsTableCreateCompanionBuilder = PresetsCompanion Function({
  required String id,
  required String moduleId,
  Value<String?> enabledFeatures,
  Value<String?> disabledFeatures,
  Value<int> rowid,
});
typedef $$PresetsTableUpdateCompanionBuilder = PresetsCompanion Function({
  Value<String> id,
  Value<String> moduleId,
  Value<String?> enabledFeatures,
  Value<String?> disabledFeatures,
  Value<int> rowid,
});

class $$PresetsTableFilterComposer
    extends Composer<_$AppDatabase, $PresetsTable> {
  $$PresetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get moduleId => $composableBuilder(
      column: $table.moduleId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get enabledFeatures => $composableBuilder(
      column: $table.enabledFeatures,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get disabledFeatures => $composableBuilder(
      column: $table.disabledFeatures,
      builder: (column) => ColumnFilters(column));
}

class $$PresetsTableOrderingComposer
    extends Composer<_$AppDatabase, $PresetsTable> {
  $$PresetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get moduleId => $composableBuilder(
      column: $table.moduleId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get enabledFeatures => $composableBuilder(
      column: $table.enabledFeatures,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get disabledFeatures => $composableBuilder(
      column: $table.disabledFeatures,
      builder: (column) => ColumnOrderings(column));
}

class $$PresetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PresetsTable> {
  $$PresetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get moduleId =>
      $composableBuilder(column: $table.moduleId, builder: (column) => column);

  GeneratedColumn<String> get enabledFeatures => $composableBuilder(
      column: $table.enabledFeatures, builder: (column) => column);

  GeneratedColumn<String> get disabledFeatures => $composableBuilder(
      column: $table.disabledFeatures, builder: (column) => column);
}

class $$PresetsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PresetsTable,
    Preset,
    $$PresetsTableFilterComposer,
    $$PresetsTableOrderingComposer,
    $$PresetsTableAnnotationComposer,
    $$PresetsTableCreateCompanionBuilder,
    $$PresetsTableUpdateCompanionBuilder,
    (Preset, BaseReferences<_$AppDatabase, $PresetsTable, Preset>),
    Preset,
    PrefetchHooks Function()> {
  $$PresetsTableTableManager(_$AppDatabase db, $PresetsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PresetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PresetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PresetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> moduleId = const Value.absent(),
            Value<String?> enabledFeatures = const Value.absent(),
            Value<String?> disabledFeatures = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PresetsCompanion(
            id: id,
            moduleId: moduleId,
            enabledFeatures: enabledFeatures,
            disabledFeatures: disabledFeatures,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String moduleId,
            Value<String?> enabledFeatures = const Value.absent(),
            Value<String?> disabledFeatures = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PresetsCompanion.insert(
            id: id,
            moduleId: moduleId,
            enabledFeatures: enabledFeatures,
            disabledFeatures: disabledFeatures,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PresetsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PresetsTable,
    Preset,
    $$PresetsTableFilterComposer,
    $$PresetsTableOrderingComposer,
    $$PresetsTableAnnotationComposer,
    $$PresetsTableCreateCompanionBuilder,
    $$PresetsTableUpdateCompanionBuilder,
    (Preset, BaseReferences<_$AppDatabase, $PresetsTable, Preset>),
    Preset,
    PrefetchHooks Function()>;
typedef $$EntityRelationsTableCreateCompanionBuilder = EntityRelationsCompanion
    Function({
  required String id,
  required String fromEntityId,
  required String toEntityId,
  required String relationType,
  Value<int> rowid,
});
typedef $$EntityRelationsTableUpdateCompanionBuilder = EntityRelationsCompanion
    Function({
  Value<String> id,
  Value<String> fromEntityId,
  Value<String> toEntityId,
  Value<String> relationType,
  Value<int> rowid,
});

class $$EntityRelationsTableFilterComposer
    extends Composer<_$AppDatabase, $EntityRelationsTable> {
  $$EntityRelationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fromEntityId => $composableBuilder(
      column: $table.fromEntityId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get toEntityId => $composableBuilder(
      column: $table.toEntityId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get relationType => $composableBuilder(
      column: $table.relationType, builder: (column) => ColumnFilters(column));
}

class $$EntityRelationsTableOrderingComposer
    extends Composer<_$AppDatabase, $EntityRelationsTable> {
  $$EntityRelationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fromEntityId => $composableBuilder(
      column: $table.fromEntityId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get toEntityId => $composableBuilder(
      column: $table.toEntityId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get relationType => $composableBuilder(
      column: $table.relationType,
      builder: (column) => ColumnOrderings(column));
}

class $$EntityRelationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EntityRelationsTable> {
  $$EntityRelationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fromEntityId => $composableBuilder(
      column: $table.fromEntityId, builder: (column) => column);

  GeneratedColumn<String> get toEntityId => $composableBuilder(
      column: $table.toEntityId, builder: (column) => column);

  GeneratedColumn<String> get relationType => $composableBuilder(
      column: $table.relationType, builder: (column) => column);
}

class $$EntityRelationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EntityRelationsTable,
    EntityRelation,
    $$EntityRelationsTableFilterComposer,
    $$EntityRelationsTableOrderingComposer,
    $$EntityRelationsTableAnnotationComposer,
    $$EntityRelationsTableCreateCompanionBuilder,
    $$EntityRelationsTableUpdateCompanionBuilder,
    (
      EntityRelation,
      BaseReferences<_$AppDatabase, $EntityRelationsTable, EntityRelation>
    ),
    EntityRelation,
    PrefetchHooks Function()> {
  $$EntityRelationsTableTableManager(
      _$AppDatabase db, $EntityRelationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EntityRelationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EntityRelationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EntityRelationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> fromEntityId = const Value.absent(),
            Value<String> toEntityId = const Value.absent(),
            Value<String> relationType = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EntityRelationsCompanion(
            id: id,
            fromEntityId: fromEntityId,
            toEntityId: toEntityId,
            relationType: relationType,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String fromEntityId,
            required String toEntityId,
            required String relationType,
            Value<int> rowid = const Value.absent(),
          }) =>
              EntityRelationsCompanion.insert(
            id: id,
            fromEntityId: fromEntityId,
            toEntityId: toEntityId,
            relationType: relationType,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$EntityRelationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EntityRelationsTable,
    EntityRelation,
    $$EntityRelationsTableFilterComposer,
    $$EntityRelationsTableOrderingComposer,
    $$EntityRelationsTableAnnotationComposer,
    $$EntityRelationsTableCreateCompanionBuilder,
    $$EntityRelationsTableUpdateCompanionBuilder,
    (
      EntityRelation,
      BaseReferences<_$AppDatabase, $EntityRelationsTable, EntityRelation>
    ),
    EntityRelation,
    PrefetchHooks Function()>;
typedef $$TasksTableCreateCompanionBuilder = TasksCompanion Function({
  required String id,
  required String ownerId,
  required String title,
  Value<String?> description,
  Value<DateTime?> startDate,
  Value<DateTime?> endDate,
  Value<String?> recurrenceRule,
  Value<String?> reminderSettings,
  Value<String> status,
  Value<String?> linkedEntityId,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$TasksTableUpdateCompanionBuilder = TasksCompanion Function({
  Value<String> id,
  Value<String> ownerId,
  Value<String> title,
  Value<String?> description,
  Value<DateTime?> startDate,
  Value<DateTime?> endDate,
  Value<String?> recurrenceRule,
  Value<String?> reminderSettings,
  Value<String> status,
  Value<String?> linkedEntityId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$TasksTableFilterComposer extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ownerId => $composableBuilder(
      column: $table.ownerId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recurrenceRule => $composableBuilder(
      column: $table.recurrenceRule,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reminderSettings => $composableBuilder(
      column: $table.reminderSettings,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get linkedEntityId => $composableBuilder(
      column: $table.linkedEntityId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$TasksTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ownerId => $composableBuilder(
      column: $table.ownerId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recurrenceRule => $composableBuilder(
      column: $table.recurrenceRule,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reminderSettings => $composableBuilder(
      column: $table.reminderSettings,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get linkedEntityId => $composableBuilder(
      column: $table.linkedEntityId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$TasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<String> get recurrenceRule => $composableBuilder(
      column: $table.recurrenceRule, builder: (column) => column);

  GeneratedColumn<String> get reminderSettings => $composableBuilder(
      column: $table.reminderSettings, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get linkedEntityId => $composableBuilder(
      column: $table.linkedEntityId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TasksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TasksTable,
    Task,
    $$TasksTableFilterComposer,
    $$TasksTableOrderingComposer,
    $$TasksTableAnnotationComposer,
    $$TasksTableCreateCompanionBuilder,
    $$TasksTableUpdateCompanionBuilder,
    (Task, BaseReferences<_$AppDatabase, $TasksTable, Task>),
    Task,
    PrefetchHooks Function()> {
  $$TasksTableTableManager(_$AppDatabase db, $TasksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> ownerId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<DateTime?> startDate = const Value.absent(),
            Value<DateTime?> endDate = const Value.absent(),
            Value<String?> recurrenceRule = const Value.absent(),
            Value<String?> reminderSettings = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> linkedEntityId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TasksCompanion(
            id: id,
            ownerId: ownerId,
            title: title,
            description: description,
            startDate: startDate,
            endDate: endDate,
            recurrenceRule: recurrenceRule,
            reminderSettings: reminderSettings,
            status: status,
            linkedEntityId: linkedEntityId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String ownerId,
            required String title,
            Value<String?> description = const Value.absent(),
            Value<DateTime?> startDate = const Value.absent(),
            Value<DateTime?> endDate = const Value.absent(),
            Value<String?> recurrenceRule = const Value.absent(),
            Value<String?> reminderSettings = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> linkedEntityId = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              TasksCompanion.insert(
            id: id,
            ownerId: ownerId,
            title: title,
            description: description,
            startDate: startDate,
            endDate: endDate,
            recurrenceRule: recurrenceRule,
            reminderSettings: reminderSettings,
            status: status,
            linkedEntityId: linkedEntityId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TasksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TasksTable,
    Task,
    $$TasksTableFilterComposer,
    $$TasksTableOrderingComposer,
    $$TasksTableAnnotationComposer,
    $$TasksTableCreateCompanionBuilder,
    $$TasksTableUpdateCompanionBuilder,
    (Task, BaseReferences<_$AppDatabase, $TasksTable, Task>),
    Task,
    PrefetchHooks Function()>;
typedef $$JournalEntriesTableCreateCompanionBuilder = JournalEntriesCompanion
    Function({
  required String id,
  required String ownerId,
  required String content,
  Value<DateTime?> startDate,
  Value<DateTime?> endDate,
  Value<String?> recurrenceRule,
  Value<String?> reminderSettings,
  Value<String?> status,
  Value<String?> linkedEntityId,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$JournalEntriesTableUpdateCompanionBuilder = JournalEntriesCompanion
    Function({
  Value<String> id,
  Value<String> ownerId,
  Value<String> content,
  Value<DateTime?> startDate,
  Value<DateTime?> endDate,
  Value<String?> recurrenceRule,
  Value<String?> reminderSettings,
  Value<String?> status,
  Value<String?> linkedEntityId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$JournalEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $JournalEntriesTable> {
  $$JournalEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ownerId => $composableBuilder(
      column: $table.ownerId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recurrenceRule => $composableBuilder(
      column: $table.recurrenceRule,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reminderSettings => $composableBuilder(
      column: $table.reminderSettings,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get linkedEntityId => $composableBuilder(
      column: $table.linkedEntityId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$JournalEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $JournalEntriesTable> {
  $$JournalEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ownerId => $composableBuilder(
      column: $table.ownerId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recurrenceRule => $composableBuilder(
      column: $table.recurrenceRule,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reminderSettings => $composableBuilder(
      column: $table.reminderSettings,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get linkedEntityId => $composableBuilder(
      column: $table.linkedEntityId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$JournalEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $JournalEntriesTable> {
  $$JournalEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<String> get recurrenceRule => $composableBuilder(
      column: $table.recurrenceRule, builder: (column) => column);

  GeneratedColumn<String> get reminderSettings => $composableBuilder(
      column: $table.reminderSettings, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get linkedEntityId => $composableBuilder(
      column: $table.linkedEntityId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$JournalEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $JournalEntriesTable,
    JournalEntry,
    $$JournalEntriesTableFilterComposer,
    $$JournalEntriesTableOrderingComposer,
    $$JournalEntriesTableAnnotationComposer,
    $$JournalEntriesTableCreateCompanionBuilder,
    $$JournalEntriesTableUpdateCompanionBuilder,
    (
      JournalEntry,
      BaseReferences<_$AppDatabase, $JournalEntriesTable, JournalEntry>
    ),
    JournalEntry,
    PrefetchHooks Function()> {
  $$JournalEntriesTableTableManager(
      _$AppDatabase db, $JournalEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JournalEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JournalEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JournalEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> ownerId = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<DateTime?> startDate = const Value.absent(),
            Value<DateTime?> endDate = const Value.absent(),
            Value<String?> recurrenceRule = const Value.absent(),
            Value<String?> reminderSettings = const Value.absent(),
            Value<String?> status = const Value.absent(),
            Value<String?> linkedEntityId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              JournalEntriesCompanion(
            id: id,
            ownerId: ownerId,
            content: content,
            startDate: startDate,
            endDate: endDate,
            recurrenceRule: recurrenceRule,
            reminderSettings: reminderSettings,
            status: status,
            linkedEntityId: linkedEntityId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String ownerId,
            required String content,
            Value<DateTime?> startDate = const Value.absent(),
            Value<DateTime?> endDate = const Value.absent(),
            Value<String?> recurrenceRule = const Value.absent(),
            Value<String?> reminderSettings = const Value.absent(),
            Value<String?> status = const Value.absent(),
            Value<String?> linkedEntityId = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              JournalEntriesCompanion.insert(
            id: id,
            ownerId: ownerId,
            content: content,
            startDate: startDate,
            endDate: endDate,
            recurrenceRule: recurrenceRule,
            reminderSettings: reminderSettings,
            status: status,
            linkedEntityId: linkedEntityId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$JournalEntriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $JournalEntriesTable,
    JournalEntry,
    $$JournalEntriesTableFilterComposer,
    $$JournalEntriesTableOrderingComposer,
    $$JournalEntriesTableAnnotationComposer,
    $$JournalEntriesTableCreateCompanionBuilder,
    $$JournalEntriesTableUpdateCompanionBuilder,
    (
      JournalEntry,
      BaseReferences<_$AppDatabase, $JournalEntriesTable, JournalEntry>
    ),
    JournalEntry,
    PrefetchHooks Function()>;
typedef $$HabitsTableCreateCompanionBuilder = HabitsCompanion Function({
  required String id,
  required String ownerId,
  required String name,
  Value<bool> completedToday,
  Value<int> rowid,
});
typedef $$HabitsTableUpdateCompanionBuilder = HabitsCompanion Function({
  Value<String> id,
  Value<String> ownerId,
  Value<String> name,
  Value<bool> completedToday,
  Value<int> rowid,
});

class $$HabitsTableFilterComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ownerId => $composableBuilder(
      column: $table.ownerId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get completedToday => $composableBuilder(
      column: $table.completedToday,
      builder: (column) => ColumnFilters(column));
}

class $$HabitsTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ownerId => $composableBuilder(
      column: $table.ownerId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get completedToday => $composableBuilder(
      column: $table.completedToday,
      builder: (column) => ColumnOrderings(column));
}

class $$HabitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get completedToday => $composableBuilder(
      column: $table.completedToday, builder: (column) => column);
}

class $$HabitsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HabitsTable,
    Habit,
    $$HabitsTableFilterComposer,
    $$HabitsTableOrderingComposer,
    $$HabitsTableAnnotationComposer,
    $$HabitsTableCreateCompanionBuilder,
    $$HabitsTableUpdateCompanionBuilder,
    (Habit, BaseReferences<_$AppDatabase, $HabitsTable, Habit>),
    Habit,
    PrefetchHooks Function()> {
  $$HabitsTableTableManager(_$AppDatabase db, $HabitsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> ownerId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<bool> completedToday = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HabitsCompanion(
            id: id,
            ownerId: ownerId,
            name: name,
            completedToday: completedToday,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String ownerId,
            required String name,
            Value<bool> completedToday = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HabitsCompanion.insert(
            id: id,
            ownerId: ownerId,
            name: name,
            completedToday: completedToday,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$HabitsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HabitsTable,
    Habit,
    $$HabitsTableFilterComposer,
    $$HabitsTableOrderingComposer,
    $$HabitsTableAnnotationComposer,
    $$HabitsTableCreateCompanionBuilder,
    $$HabitsTableUpdateCompanionBuilder,
    (Habit, BaseReferences<_$AppDatabase, $HabitsTable, Habit>),
    Habit,
    PrefetchHooks Function()>;
typedef $$ProjectsTableCreateCompanionBuilder = ProjectsCompanion Function({
  required String id,
  required String ownerId,
  required String title,
  Value<String?> status,
  Value<int> rowid,
});
typedef $$ProjectsTableUpdateCompanionBuilder = ProjectsCompanion Function({
  Value<String> id,
  Value<String> ownerId,
  Value<String> title,
  Value<String?> status,
  Value<int> rowid,
});

class $$ProjectsTableFilterComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ownerId => $composableBuilder(
      column: $table.ownerId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));
}

class $$ProjectsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ownerId => $composableBuilder(
      column: $table.ownerId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));
}

class $$ProjectsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$ProjectsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProjectsTable,
    Project,
    $$ProjectsTableFilterComposer,
    $$ProjectsTableOrderingComposer,
    $$ProjectsTableAnnotationComposer,
    $$ProjectsTableCreateCompanionBuilder,
    $$ProjectsTableUpdateCompanionBuilder,
    (Project, BaseReferences<_$AppDatabase, $ProjectsTable, Project>),
    Project,
    PrefetchHooks Function()> {
  $$ProjectsTableTableManager(_$AppDatabase db, $ProjectsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> ownerId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> status = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProjectsCompanion(
            id: id,
            ownerId: ownerId,
            title: title,
            status: status,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String ownerId,
            required String title,
            Value<String?> status = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProjectsCompanion.insert(
            id: id,
            ownerId: ownerId,
            title: title,
            status: status,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ProjectsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProjectsTable,
    Project,
    $$ProjectsTableFilterComposer,
    $$ProjectsTableOrderingComposer,
    $$ProjectsTableAnnotationComposer,
    $$ProjectsTableCreateCompanionBuilder,
    $$ProjectsTableUpdateCompanionBuilder,
    (Project, BaseReferences<_$AppDatabase, $ProjectsTable, Project>),
    Project,
    PrefetchHooks Function()>;
typedef $$FinanceRecordsTableCreateCompanionBuilder = FinanceRecordsCompanion
    Function({
  required String id,
  required String ownerId,
  required double amount,
  Value<String?> category,
  required DateTime date,
  Value<int> rowid,
});
typedef $$FinanceRecordsTableUpdateCompanionBuilder = FinanceRecordsCompanion
    Function({
  Value<String> id,
  Value<String> ownerId,
  Value<double> amount,
  Value<String?> category,
  Value<DateTime> date,
  Value<int> rowid,
});

class $$FinanceRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $FinanceRecordsTable> {
  $$FinanceRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ownerId => $composableBuilder(
      column: $table.ownerId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));
}

class $$FinanceRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $FinanceRecordsTable> {
  $$FinanceRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ownerId => $composableBuilder(
      column: $table.ownerId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));
}

class $$FinanceRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FinanceRecordsTable> {
  $$FinanceRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);
}

class $$FinanceRecordsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FinanceRecordsTable,
    FinanceRecord,
    $$FinanceRecordsTableFilterComposer,
    $$FinanceRecordsTableOrderingComposer,
    $$FinanceRecordsTableAnnotationComposer,
    $$FinanceRecordsTableCreateCompanionBuilder,
    $$FinanceRecordsTableUpdateCompanionBuilder,
    (
      FinanceRecord,
      BaseReferences<_$AppDatabase, $FinanceRecordsTable, FinanceRecord>
    ),
    FinanceRecord,
    PrefetchHooks Function()> {
  $$FinanceRecordsTableTableManager(
      _$AppDatabase db, $FinanceRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FinanceRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FinanceRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FinanceRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> ownerId = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String?> category = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FinanceRecordsCompanion(
            id: id,
            ownerId: ownerId,
            amount: amount,
            category: category,
            date: date,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String ownerId,
            required double amount,
            Value<String?> category = const Value.absent(),
            required DateTime date,
            Value<int> rowid = const Value.absent(),
          }) =>
              FinanceRecordsCompanion.insert(
            id: id,
            ownerId: ownerId,
            amount: amount,
            category: category,
            date: date,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FinanceRecordsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FinanceRecordsTable,
    FinanceRecord,
    $$FinanceRecordsTableFilterComposer,
    $$FinanceRecordsTableOrderingComposer,
    $$FinanceRecordsTableAnnotationComposer,
    $$FinanceRecordsTableCreateCompanionBuilder,
    $$FinanceRecordsTableUpdateCompanionBuilder,
    (
      FinanceRecord,
      BaseReferences<_$AppDatabase, $FinanceRecordsTable, FinanceRecord>
    ),
    FinanceRecord,
    PrefetchHooks Function()>;
typedef $$HealthRecordsTableCreateCompanionBuilder = HealthRecordsCompanion
    Function({
  required String id,
  required String ownerId,
  required String type,
  Value<String?> value,
  required DateTime date,
  Value<int> rowid,
});
typedef $$HealthRecordsTableUpdateCompanionBuilder = HealthRecordsCompanion
    Function({
  Value<String> id,
  Value<String> ownerId,
  Value<String> type,
  Value<String?> value,
  Value<DateTime> date,
  Value<int> rowid,
});

class $$HealthRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $HealthRecordsTable> {
  $$HealthRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ownerId => $composableBuilder(
      column: $table.ownerId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));
}

class $$HealthRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $HealthRecordsTable> {
  $$HealthRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ownerId => $composableBuilder(
      column: $table.ownerId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));
}

class $$HealthRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HealthRecordsTable> {
  $$HealthRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);
}

class $$HealthRecordsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HealthRecordsTable,
    HealthRecord,
    $$HealthRecordsTableFilterComposer,
    $$HealthRecordsTableOrderingComposer,
    $$HealthRecordsTableAnnotationComposer,
    $$HealthRecordsTableCreateCompanionBuilder,
    $$HealthRecordsTableUpdateCompanionBuilder,
    (
      HealthRecord,
      BaseReferences<_$AppDatabase, $HealthRecordsTable, HealthRecord>
    ),
    HealthRecord,
    PrefetchHooks Function()> {
  $$HealthRecordsTableTableManager(_$AppDatabase db, $HealthRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HealthRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HealthRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HealthRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> ownerId = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String?> value = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HealthRecordsCompanion(
            id: id,
            ownerId: ownerId,
            type: type,
            value: value,
            date: date,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String ownerId,
            required String type,
            Value<String?> value = const Value.absent(),
            required DateTime date,
            Value<int> rowid = const Value.absent(),
          }) =>
              HealthRecordsCompanion.insert(
            id: id,
            ownerId: ownerId,
            type: type,
            value: value,
            date: date,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$HealthRecordsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HealthRecordsTable,
    HealthRecord,
    $$HealthRecordsTableFilterComposer,
    $$HealthRecordsTableOrderingComposer,
    $$HealthRecordsTableAnnotationComposer,
    $$HealthRecordsTableCreateCompanionBuilder,
    $$HealthRecordsTableUpdateCompanionBuilder,
    (
      HealthRecord,
      BaseReferences<_$AppDatabase, $HealthRecordsTable, HealthRecord>
    ),
    HealthRecord,
    PrefetchHooks Function()>;
typedef $$MenstruationCyclesTableCreateCompanionBuilder
    = MenstruationCyclesCompanion Function({
  required String id,
  required String ownerId,
  required DateTime startDate,
  Value<DateTime?> endDate,
  Value<int> rowid,
});
typedef $$MenstruationCyclesTableUpdateCompanionBuilder
    = MenstruationCyclesCompanion Function({
  Value<String> id,
  Value<String> ownerId,
  Value<DateTime> startDate,
  Value<DateTime?> endDate,
  Value<int> rowid,
});

class $$MenstruationCyclesTableFilterComposer
    extends Composer<_$AppDatabase, $MenstruationCyclesTable> {
  $$MenstruationCyclesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ownerId => $composableBuilder(
      column: $table.ownerId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnFilters(column));
}

class $$MenstruationCyclesTableOrderingComposer
    extends Composer<_$AppDatabase, $MenstruationCyclesTable> {
  $$MenstruationCyclesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ownerId => $composableBuilder(
      column: $table.ownerId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnOrderings(column));
}

class $$MenstruationCyclesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MenstruationCyclesTable> {
  $$MenstruationCyclesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);
}

class $$MenstruationCyclesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MenstruationCyclesTable,
    MenstruationCycle,
    $$MenstruationCyclesTableFilterComposer,
    $$MenstruationCyclesTableOrderingComposer,
    $$MenstruationCyclesTableAnnotationComposer,
    $$MenstruationCyclesTableCreateCompanionBuilder,
    $$MenstruationCyclesTableUpdateCompanionBuilder,
    (
      MenstruationCycle,
      BaseReferences<_$AppDatabase, $MenstruationCyclesTable, MenstruationCycle>
    ),
    MenstruationCycle,
    PrefetchHooks Function()> {
  $$MenstruationCyclesTableTableManager(
      _$AppDatabase db, $MenstruationCyclesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MenstruationCyclesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MenstruationCyclesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MenstruationCyclesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> ownerId = const Value.absent(),
            Value<DateTime> startDate = const Value.absent(),
            Value<DateTime?> endDate = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MenstruationCyclesCompanion(
            id: id,
            ownerId: ownerId,
            startDate: startDate,
            endDate: endDate,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String ownerId,
            required DateTime startDate,
            Value<DateTime?> endDate = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MenstruationCyclesCompanion.insert(
            id: id,
            ownerId: ownerId,
            startDate: startDate,
            endDate: endDate,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MenstruationCyclesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MenstruationCyclesTable,
    MenstruationCycle,
    $$MenstruationCyclesTableFilterComposer,
    $$MenstruationCyclesTableOrderingComposer,
    $$MenstruationCyclesTableAnnotationComposer,
    $$MenstruationCyclesTableCreateCompanionBuilder,
    $$MenstruationCyclesTableUpdateCompanionBuilder,
    (
      MenstruationCycle,
      BaseReferences<_$AppDatabase, $MenstruationCyclesTable, MenstruationCycle>
    ),
    MenstruationCycle,
    PrefetchHooks Function()>;
typedef $$NutritionEntriesTableCreateCompanionBuilder
    = NutritionEntriesCompanion Function({
  required String id,
  required String ownerId,
  required String meal,
  Value<String?> notes,
  required DateTime date,
  Value<int> rowid,
});
typedef $$NutritionEntriesTableUpdateCompanionBuilder
    = NutritionEntriesCompanion Function({
  Value<String> id,
  Value<String> ownerId,
  Value<String> meal,
  Value<String?> notes,
  Value<DateTime> date,
  Value<int> rowid,
});

class $$NutritionEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $NutritionEntriesTable> {
  $$NutritionEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ownerId => $composableBuilder(
      column: $table.ownerId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get meal => $composableBuilder(
      column: $table.meal, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));
}

class $$NutritionEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $NutritionEntriesTable> {
  $$NutritionEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ownerId => $composableBuilder(
      column: $table.ownerId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get meal => $composableBuilder(
      column: $table.meal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));
}

class $$NutritionEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NutritionEntriesTable> {
  $$NutritionEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumn<String> get meal =>
      $composableBuilder(column: $table.meal, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);
}

class $$NutritionEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NutritionEntriesTable,
    NutritionEntry,
    $$NutritionEntriesTableFilterComposer,
    $$NutritionEntriesTableOrderingComposer,
    $$NutritionEntriesTableAnnotationComposer,
    $$NutritionEntriesTableCreateCompanionBuilder,
    $$NutritionEntriesTableUpdateCompanionBuilder,
    (
      NutritionEntry,
      BaseReferences<_$AppDatabase, $NutritionEntriesTable, NutritionEntry>
    ),
    NutritionEntry,
    PrefetchHooks Function()> {
  $$NutritionEntriesTableTableManager(
      _$AppDatabase db, $NutritionEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NutritionEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NutritionEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NutritionEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> ownerId = const Value.absent(),
            Value<String> meal = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NutritionEntriesCompanion(
            id: id,
            ownerId: ownerId,
            meal: meal,
            notes: notes,
            date: date,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String ownerId,
            required String meal,
            Value<String?> notes = const Value.absent(),
            required DateTime date,
            Value<int> rowid = const Value.absent(),
          }) =>
              NutritionEntriesCompanion.insert(
            id: id,
            ownerId: ownerId,
            meal: meal,
            notes: notes,
            date: date,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$NutritionEntriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $NutritionEntriesTable,
    NutritionEntry,
    $$NutritionEntriesTableFilterComposer,
    $$NutritionEntriesTableOrderingComposer,
    $$NutritionEntriesTableAnnotationComposer,
    $$NutritionEntriesTableCreateCompanionBuilder,
    $$NutritionEntriesTableUpdateCompanionBuilder,
    (
      NutritionEntry,
      BaseReferences<_$AppDatabase, $NutritionEntriesTable, NutritionEntry>
    ),
    NutritionEntry,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$ModulesTableTableManager get modules =>
      $$ModulesTableTableManager(_db, _db.modules);
  $$FeatureTogglesTableTableManager get featureToggles =>
      $$FeatureTogglesTableTableManager(_db, _db.featureToggles);
  $$PresetsTableTableManager get presets =>
      $$PresetsTableTableManager(_db, _db.presets);
  $$EntityRelationsTableTableManager get entityRelations =>
      $$EntityRelationsTableTableManager(_db, _db.entityRelations);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db, _db.tasks);
  $$JournalEntriesTableTableManager get journalEntries =>
      $$JournalEntriesTableTableManager(_db, _db.journalEntries);
  $$HabitsTableTableManager get habits =>
      $$HabitsTableTableManager(_db, _db.habits);
  $$ProjectsTableTableManager get projects =>
      $$ProjectsTableTableManager(_db, _db.projects);
  $$FinanceRecordsTableTableManager get financeRecords =>
      $$FinanceRecordsTableTableManager(_db, _db.financeRecords);
  $$HealthRecordsTableTableManager get healthRecords =>
      $$HealthRecordsTableTableManager(_db, _db.healthRecords);
  $$MenstruationCyclesTableTableManager get menstruationCycles =>
      $$MenstruationCyclesTableTableManager(_db, _db.menstruationCycles);
  $$NutritionEntriesTableTableManager get nutritionEntries =>
      $$NutritionEntriesTableTableManager(_db, _db.nutritionEntries);
}
