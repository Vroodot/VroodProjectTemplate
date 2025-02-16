class_name TextureHelper

static func get_texture_dimensions(texture: Texture2D) -> Rect2i:
	return texture.get_image().get_used_rect()


static func get_texture_rect_dimensions(texture_rect: TextureRect) -> Vector2:
	var texture: Texture2D = texture_rect.texture
	var used_rect: Rect2i = get_texture_dimensions(texture)
	var texture_dimensions: Vector2 = Vector2(used_rect.size) * texture_rect.scale

	return texture_dimensions


static func get_sprite_dimensions(sprite: Sprite2D) -> Vector2:
	var texture: Texture2D = sprite.texture
	var used_rect: Rect2i = get_texture_dimensions(texture)
	var sprite_dimensions: Vector2 = Vector2(used_rect.size) * sprite.scale

	return sprite_dimensions
