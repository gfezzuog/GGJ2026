class_name LevelData extends Resource

## Indica se il layer sia disabilitato e altre cose. In particolare
## il primo bit indica se il layer è disabilitato;
## il secondo indica se il pulsante di visibility è disabilitato;
## il terzo indica se il pulsante di rotazione è disabilitato;
## il quarto indica se il pulsante di visibility è premuto oppure no;
@export var layers: Array[int] = [1]
@export var layers_textures: Array[Texture]
@export var masks: Array[Mask] = [null]
