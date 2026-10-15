class_name SkillData
extends Resource

enum Kind { FLAT, PERCENT }

# Stat: &"speed", &"damage", &"health"
# Kind: FLAT or PERCENT
@export var display_name: String
@export_multiline var description: String
@export var icon: Texture2D
@export var cost: int = 5
@export var stat: StringName   
@export var kind: Kind = Kind.PERCENT
@export var amount: float = 0.1
