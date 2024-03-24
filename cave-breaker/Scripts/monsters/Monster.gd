extends Resource
class_name Monster

enum Rank {
	BLOB,
	CHILD,
	TEEN,
	ADULT,
	ELDER,
	SPECIAL
}

# Metadata of the monster
@export var id: String = "MONSTER"
@export var name: String = "monster"
@export var rank: Rank = Rank.BLOB

# Textures of the monster
@export var sprite: CompressedTexture2D = null
@export var slot_unactive: CompressedTexture2D = null
@export var slot_active: CompressedTexture2D = null

@export var power_count: int = 1
@export var power: Power = null
