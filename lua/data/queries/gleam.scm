(external_type
    (visibility_modifier)? @local.scope
    "type" @local.scope
    (type_name) @local.definition.type)

(type_definition
    (visibility_modifier)? @local.scope
    (opacity_modifier)?
    "type" @local.scope
    (type_name) @local.definition.type)

(data_constructor
    (constructor_name) @local.definition.constructor)

(data_constructor_argument
    (label) @local.definition.argument)

(type_alias
    (visibility_modifier)? @local.scope
    "type" @local.scope
    (type_name) @local.definition.type)

(function
    (visibility_modifier)? @local.scope
    "fn" @local.scope
    name: (_) @local.definition.function)

(constant
    (visibility_modifier)? @local.scope
    "const" @local.scope
    name: (_) @local.definition.constant)
