GDPC                �                                                                      +   X   res://.godot/exported/133200997/export-47f386c24b16dd91f577a4ac668032d1-TestWorld.scn   P�           {�:�S���0ެ�{a�    T   res://.godot/exported/133200997/export-5f8cd2ce024831180dd536a2fbf1e452-ChatMsg.scn        �      ��K����w�O���U0    T   res://.godot/exported/133200997/export-7a4564b24eab0c8b8ee58fb9c950f040-World.scn   �G     +"      ��3�"ћT������fV    T   res://.godot/exported/133200997/export-ab6556a6fc4d67ce1c752ca03758181a-Drone.scn   �i      a�      활y5h��@;?_��    X   res://.godot/exported/133200997/export-af8e4e7983455cc5bbfdb96e03ee3055-CheckPoint.scn  `(      �      q8T�^H ���@0k    P   res://.godot/exported/133200997/export-b12ae16896261643def6ef30add8aed7-Chat.scn       �      V�'�ے(����nb�    X   res://.godot/exported/133200997/export-c2fdec385dbedebf546a6c3d6c465003-UpdatePanel.scn p�     Q
      Q�?�9����p���|�    \   res://.godot/exported/133200997/export-c6cb43e1a7bc749adbfb5cb805a24b35-curve_visualizer.scnp>      �	      �mH쇣=1�e���PI�    X   res://.godot/exported/133200997/export-e68a5b5581ae8f88ef78f3ea4a322a38-GridmapScene.scn�v           @�}j���7��¿��A    X   res://.godot/exported/133200997/export-efe35a19a1e98824c2fb630023711355-CurveNode.res   �:      �      ~�f"U���fO�n    X   res://.godot/exported/133200997/export-f17374307c6805240bcd90c9abcb81f6-race_manager.scn :           �{�L����|<[�I    ,   res://.godot/global_script_class_cache.cfg  ��     (      �?�k�n�ɝ��{���    H   res://.godot/imported/Circle.png-5aa705d158b14b9f860407e6f23b289d.ctex  �i     @      ����6�lkGE���E    X   res://.godot/imported/Kenney Future Narrow.ttf-4d942de0caa573f3771419998628f0fe.fontdata��     �!      60}WHZ�d�F�dL�    T   res://.godot/imported/Kenney Future.ttf-fd1f813a9c064cd591bf3582d7978539.fontdata   P�     D"      )UF]�u� �r�~��    D   res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex�x           ：Qt�E�cO���       res://.godot/uid_cache.bin  ��     P      �5��i3�/�Q       res://ACTIVE/Multiplayer.gd         :      ���n#kz�¸q|       res://Circle.png.import �k     �       ">�\���圼�z�
f       res://CurveVisualizer.gd�l     �      ���M��������M       res://Game/Objects/Chat.gd  @      �      ������� x�NU���    $   res://Game/Objects/Chat.tscn.remap  ��     a       ��
s{eg������p�        res://Game/Objects/ChatMsg.gd   �      L      2��]u�����    (   res://Game/Objects/ChatMsg.tscn.remap   @�     d       FL��>��%�c���<�        res://Game/Objects/CheckPoint.gd�!      ~      ��b=D�ѕ��z�z    (   res://Game/Objects/CheckPoint.tscn.remap��     g       �`M�;�CW{�B����    (   res://Game/Objects/CheckpointManager.gd :      �       �}sX?'�_ j��2    (   res://Game/Objects/CurveNode.tres.remap  �     f       #�˷�'H�u���A       res://Game/Objects/Drone.gd pH      D!      �:���N�ك�V�r�    $   res://Game/Objects/Drone.tscn.remap  �     b       MS���3���=u��    $   res://Game/Objects/World.tscn.remap ��     b       �+![R{�.��o��    0   res://Game/Objects/curve_visualizer.tscn.remap  ��     m       �xi6߂b�Z�O�3�    $   res://Game/Objects/race_manager.gd  06     �      "��s��:v�Lς�}    ,   res://Game/Objects/race_manager.tscn.remap  p�     i       �>5
�,L�@�o��       res://GameUpdate.gd `o     %      �v�G�����        res://GridmapScene.tscn.remap   P�     i       ����j^h�"�-�    (   res://Kenney Future Narrow.ttf.import   ��     �       Hc����j���+s3�        res://Kenney Future.ttf.import  ��     �       A���
�Ix"����^       res://TestWorld.tscn.remap  ��     f       ,�y_$LOy�Z��V7�       res://UpdatePanel.tscn.remap0�     h       `w7^�����6���       res://icon.svg  ��     �      k����X3Y���f       res://icon.svg.import   Ѕ     �       ���X�ڪ�n"�\)�       res://project.binary��     �      7���a��Oȑ���G�                extends Node

@export var checkpoint_manage : checkpoint_manager

var enet = ENetMultiplayerPeer.new()

signal peer_joined(id, username)
signal peer_left(id)
signal player_name_changed(id, name)

signal player_sync(id, player_info)

var player_username = ""
var usernames = {}

var server = false
@export var username_file = "user://active_username.txt"

func _physics_process(delta):
	if $Players.has_node(str(multiplayer.get_unique_id())):
		if checkpoint_manage:
			checkpoint_manage.player_position = $Players.get_node(str(multiplayer.get_unique_id())).global_position

func _ready():
	peer_joined.connect(add_player)
	peer_left.connect(remove_player)
	
	if FileAccess.file_exists(username_file): %Username.text = str(get_username_from_file(username_file))

func host(port):
	enet.create_server(65501)
	multiplayer.multiplayer_peer = enet
	enet.peer_connected.connect(peer_c)
	enet.peer_disconnected.connect(peer_dc)
	server = true
	%NetworkUI.queue_free()

func join(ip, port):
	enet.create_client(ip, port)
	multiplayer.multiplayer_peer = enet
	server = false
	if player_username.replace(" ", "") == "": 
		player_username = "Player %s" % multiplayer.get_peers().size()
	%NetworkUI.queue_free()


func peer_c(id): 
	print("peer %s connected" % id)
	var peers_list = multiplayer.get_peers()
	peers_list.append(1)
	get_player_username.rpc_id(id)
	await(get_tree().create_timer(1).timeout)
	print(usernames)
	
	add_player(id, str(usernames.get(id)))
	
	add_all_players.rpc_id(id, peers_list, usernames)
	
	if server: 
		for peer in multiplayer.get_peers():
			if not peer == id:
				signal_player_joined.rpc_id(peer, id, str(usernames.get(id)))

func peer_dc(id): 
	print("peer %s disconnected" % id)
	remove_player(id)
	if server: for peer in multiplayer.get_peers(): signal_player_left.rpc_id(peer, id)
	

func _on_connect_pressed():
	var ip = %ServerIP.text
	var port = %ServerPort.text.to_int()
	join(ip, port)
	%NetworkUI.queue_free()
	player_username = str(%Username.text)
	save_username_to_file(player_username, username_file)

func _on_host_pressed():
	var port = %ServerPort.text.to_int()
	host(port)
	
	%NetworkUI.queue_free()
	player_username = %Username.text
	save_username_to_file(player_username, username_file)
	add_player(1, player_username)

func set_player_name(peer_id, player_name):
	if player_name.replace(" ", "") == "": 
		player_name = "Player %s" % multiplayer.get_peers().size()
	$Players.get_node(str(peer_id)).set_username(str(player_name))
	usernames[peer_id] = player_name

@rpc("any_peer") func add_all_players(players : Array, username_list : Dictionary):
	print(multiplayer.get_unique_id(), " adding all players ", players, username_list)
	for player in players:
		if username_list.has(player): add_player(player, username_list.get(player))
		if not username_list.has(player): add_player(player, "failed to find username")

@rpc("any_peer") func get_player_username(peer := 0, username := ""):
	if not server:
		get_player_username.rpc_id(multiplayer.get_remote_sender_id(), multiplayer.get_unique_id(), player_username)
	if server: 
		print("got player username ", username)
		usernames[peer] = username

@rpc("any_peer") func signal_player_joined(peer, username): 
	printt(multiplayer.get_unique_id(), "got join for ", peer)
	get_player_username.rpc_id(1, peer, "")
	peer_joined.emit(peer, username)

@rpc("any_peer") func signal_player_left(peer): 
	printt(multiplayer.get_unique_id(), "got leave for ", peer)
	
	peer_left.emit(peer)

func add_player(peer_id, username := ""):
	print(multiplayer.get_unique_id(), ' adding player ', peer_id, " ", username)
	var player = preload("res://Game/Objects/Drone.tscn").instantiate()
	$Players.add_child(player)
	player.set_id(peer_id)
	player.username = username
	
	set_player_name(peer_id, username)
	
	player.set_multiplayer_authority(peer_id)

func save_username_to_file(username, file_path):
	var fs = FileAccess.open(file_path, FileAccess.WRITE)
	fs.store_string(username)
	fs.close()

func get_username_from_file(file_path):
	return FileAccess.get_file_as_string(file_path)

func request_peers(node):
	return multiplayer.get_peers()

func request_multiplayer(node):
	return get_multiplayer()

func remove_player(peer_id):
	for c in $Players.get_children(): 
		c.recieve_message($Players.get_node(str(peer_id)).username, "Left the Game!", $Players.get_node(str(peer_id)).color)
	$Players.get_node(str(peer_id)).queue_free()
      extends Control

@export var chat_messages : VBoxContainer
@export var chat_box : LineEdit
@export var scroll : ScrollContainer
@export var username : String
signal chat_message_sent (username, text, color)

func _ready():
	chat_box.text_submitted.connect(chat_message_submitted)

func chat_message_submitted(text):
	if not text.replace(" ", "") == "":
		chat_message_sent.emit(username, text, get_parent().get_parent().color)
		chat_message_recieved(username, text, get_parent().get_parent().color)
		chat_box.text = ""

func chat_message_recieved(username, message, color):
	await(get_tree().create_timer(0.1).timeout)
	var chat_message = preload("res://Game/Objects/ChatMsg.tscn").instantiate()
	chat_messages.add_child(chat_message)
	print(chat_message)
	await(get_tree().create_timer(0.1).timeout)
	chat_message.assign(username, message, color)
	for i in 10:
		scroll.set_deferred("scroll_vertical", scroll.get_v_scroll_bar().max_value + 1)

             RSRC                    PackedScene            ��������                                                  VBoxContainer    ScrollContainer 	   ChatEdit    resource_local_to_scene    resource_name 	   _bundled    script       Script    res://Game/Objects/Chat.gd ��������	   FontFile    res://Kenney Future Narrow.ttf ��G�      local://PackedScene_1pxfo }         PackedScene          	         names "         Chat    custom_minimum_size    layout_mode    anchor_right    anchor_bottom    grow_horizontal    grow_vertical    script    chat_messages 	   chat_box    scroll    metadata/_edit_use_anchors_    Control    VBoxContainer    anchors_preset    anchor_top $   theme_override_constants/separation    ScrollContainer    horizontal_scroll_mode 	   ChatEdit    theme_override_fonts/font    placeholder_text 	   LineEdit    	   variants       
     �C  hC         �8�>   O�>                                                                          ����   o�e�   33�?   �i�?      
     �C  @C       
          B               Click Here To Chat       node_count             nodes     ]   ��������       ����                                                @   	  @   
  @      	                     ����	      
                                                	                    ����                                      ����                                ����                                     conn_count              conns               node_paths              editable_instances              version             RSRC              extends RichTextLabel

func assign(username, message, color): 
	print_rich(str("[color=#%s]%s[color=#ffffff]: %s" % [color.to_html(), username, message]))
	self.text = str("[color=#8a8a8a]%s [color=#ffffff]| [color=#%s]%s[color=#ffffff]: %s\n\n" % [str(Time.get_time_string_from_system(false)), color.to_html(), username, message])
    RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script    	   FontFile    res://Kenney Future Narrow.ttf ��G�   Script    res://Game/Objects/ChatMsg.gd ��������      local://PackedScene_uif1s M         PackedScene          	         names "         ChatMsg    custom_minimum_size    anchor_right    anchor_bottom    grow_horizontal    grow_vertical !   theme_override_fonts/normal_font    theme_override_fonts/bold_font "   theme_override_fonts/italics_font '   theme_override_fonts/bold_italics_font    theme_override_fonts/mono_font    bbcode_enabled    fit_content    scroll_active    script    metadata/_edit_use_anchors_    RichTextLabel    	   variants       
     �C  �A   �8�>   �=                                            node_count             nodes     %   ��������       ����                                                    	      
                                              conn_count              conns               node_paths              editable_instances              version             RSRC     extends Node3D
class_name checkpoint

@export var checkpoint_id = 0
@export var checkpoint_required = true

@export var checkpoint_enabled = false

@export var stock_color = Color("#ffffff7f")
@export var captured_color = Color("#00c9277f")

@export var mesh : MeshInstance3D

@export var checkpoint_management : checkpoint_manager

func _ready():
	self.name = str(checkpoint_id)

var f = 0

func _physics_process(delta):
	f += 1
	if f == 10:
		var material = mesh.material_override.duplicate() as StandardMaterial3D
		if checkpoint_enabled: 
			material.albedo_color = captured_color
			material.emission = captured_color
		
		if not checkpoint_enabled: 
			material.albedo_color = stock_color
			material.emission = stock_color
		
		mesh.material_override = material
		f = 0
	
	if checkpoint_management:
		%Dist.text = str(round(global_position.distance_to(checkpoint_management.player_position)), "m")

func _on_area_3d_body_entered(body):
	print(checkpoint_management.current_checkpoint )
	if body is CharacterBody3D:
		var last_checkpoint = "../%s" % str(checkpoint_id-1)
		if has_node(last_checkpoint):
			last_checkpoint = get_node(last_checkpoint) as checkpoint
			
			if last_checkpoint.checkpoint_required:
				
				if last_checkpoint.checkpoint_enabled:
					checkpoint_enabled = true
					checkpoint_management.current_checkpoint = checkpoint_id
					
					return
			if not last_checkpoint.checkpoint_required: 
				checkpoint_enabled = true
				checkpoint_management.current_checkpoint = checkpoint_id
				
		if not has_node("../%s" % str(checkpoint_id-1)):
			checkpoint_enabled = true
			checkpoint_management.current_checkpoint = checkpoint_id
 
  RSRC                    PackedScene            ��������                                            ~      CheckPointMesh    resource_local_to_scene    resource_name    render_priority 
   next_pass    transparency    blend_mode 
   cull_mode    depth_draw_mode    no_depth_test    shading_mode    diffuse_mode    specular_mode    disable_ambient_light    disable_fog    vertex_color_use_as_albedo    vertex_color_is_srgb    albedo_color    albedo_texture    albedo_texture_force_srgb    albedo_texture_msdf 	   metallic    metallic_specular    metallic_texture    metallic_texture_channel 
   roughness    roughness_texture    roughness_texture_channel    emission_enabled 	   emission    emission_energy_multiplier    emission_operator    emission_on_uv2    emission_texture    normal_enabled    normal_scale    normal_texture    rim_enabled    rim 	   rim_tint    rim_texture    clearcoat_enabled 
   clearcoat    clearcoat_roughness    clearcoat_texture    anisotropy_enabled    anisotropy    anisotropy_flowmap    ao_enabled    ao_light_affect    ao_texture 
   ao_on_uv2    ao_texture_channel    heightmap_enabled    heightmap_scale    heightmap_deep_parallax    heightmap_flip_tangent    heightmap_flip_binormal    heightmap_texture    heightmap_flip_texture    subsurf_scatter_enabled    subsurf_scatter_strength    subsurf_scatter_skin_mode    subsurf_scatter_texture &   subsurf_scatter_transmittance_enabled $   subsurf_scatter_transmittance_color &   subsurf_scatter_transmittance_texture $   subsurf_scatter_transmittance_depth $   subsurf_scatter_transmittance_boost    backlight_enabled 
   backlight    backlight_texture    refraction_enabled    refraction_scale    refraction_texture    refraction_texture_channel    detail_enabled    detail_mask    detail_blend_mode    detail_uv_layer    detail_albedo    detail_normal 
   uv1_scale    uv1_offset    uv1_triplanar    uv1_triplanar_sharpness    uv1_world_triplanar 
   uv2_scale    uv2_offset    uv2_triplanar    uv2_triplanar_sharpness    uv2_world_triplanar    texture_filter    texture_repeat    disable_receive_shadows    shadow_to_opacity    billboard_mode    billboard_keep_scale    grow    grow_amount    fixed_size    use_point_size    point_size    use_particle_trails    proximity_fade_enabled    proximity_fade_distance    msdf_pixel_range    msdf_outline_size    distance_fade_mode    distance_fade_min_distance    distance_fade_max_distance    script    lightmap_size_hint 	   material    custom_aabb    flip_faces    add_uv2    uv2_padding    radius    height    radial_segments    rings    is_hemisphere    custom_solver_bias    margin 	   _bundled       Script !   res://Game/Objects/CheckPoint.gd ��������	   FontFile    res://Kenney Future Narrow.ttf ��G�   !   local://StandardMaterial3D_stwr0 �         local://SphereMesh_u3ape G         local://SphereShape3D_fj48v z         local://PackedScene_ohbts �         StandardMaterial3D                              �?  �?  �?���>                 �?  �?  �?  �?o         SphereMesh    v        HBw        �Bo         SphereShape3D    v        HBo         PackedScene    }      	         names "         CheckPoint    script    stock_color    mesh    Node3D    Dist    unique_name_in_owner    sorting_offset    pixel_size 
   billboard    double_sided    no_depth_test    fixed_size    alpha_hash_scale    alpha_antialiasing_mode    texture_filter    render_priority 	   modulate    text    font    Label3D    CheckPointMesh    material_override    MeshInstance3D    Area3D    CollisionShape3D    shape    _on_area_3d_body_entered    body_entered    	   variants                      �?  �?  �?�� >                     �B   ���:                   @         ��?��?��?  �?      TEST                                            node_count             nodes     K   ��������       ����                  @                     ����                     	      
                           	                  
                                 ����                                ����                     ����                   conn_count             conns                                                             node_paths              editable_instances              version       o      RSRC       extends Node3D
class_name checkpoint_manager

@export var player_position = Vector3.ZERO

@export var checkpoints_needed = 0
@export var current_checkpoint = 0

               RSRC                    StyleBoxFlat            ��������                                                  resource_local_to_scene    resource_name    content_margin_left    content_margin_top    content_margin_right    content_margin_bottom 	   bg_color    draw_center    skew    border_width_left    border_width_top    border_width_right    border_width_bottom    border_color    border_blend    corner_radius_top_left    corner_radius_top_right    corner_radius_bottom_right    corner_radius_bottom_left    corner_detail    expand_margin_left    expand_margin_top    expand_margin_right    expand_margin_bottom    shadow_color    shadow_size    shadow_offset    anti_aliasing    anti_aliasing_size    script           local://StyleBoxFlat_vl8cn          StyleBoxFlat 
             	         
                                                                     RSRC          RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name    content_margin_left    content_margin_top    content_margin_right    content_margin_bottom 	   bg_color    draw_center    skew    border_width_left    border_width_top    border_width_right    border_width_bottom    border_color    border_blend    corner_radius_top_left    corner_radius_top_right    corner_radius_bottom_right    corner_radius_bottom_left    corner_detail    expand_margin_left    expand_margin_top    expand_margin_right    expand_margin_bottom    shadow_color    shadow_size    shadow_offset    anti_aliasing    anti_aliasing_size    script 	   _bundled       Script    res://CurveVisualizer.gd ��������      local://StyleBoxFlat_w8qaa {         local://PackedScene_mtq1f �         StyleBoxFlat          ��k>��k>��k>  �?         PackedScene          	         names "         CurveVisualizer    custom_minimum_size    layout_mode    anchor_right    anchor_bottom    grow_horizontal    grow_vertical    script    metadata/_edit_use_anchors_    Control    Panel    anchors_preset    theme_override_styles/panel    Line    unique_name_in_owner    width    Line2D    MaxRate    anchor_left 
   max_value    VSlider    LeftTan    anchor_top 
   min_value    step    HSlider 	   RightTan    _on_v_slider_value_changed    value_changed    _on_left_tan_value_changed    _on_right_tan_value_changed    	   variants       
     �B  �B         *��=   ��0>                      
     �B  �B         ����     `?   Զm?                @     �?      D   �$�?     @�     @@)   {�G�z�?   �m�?      node_count             nodes     �   ��������	       ����                                                                
   
   ����	                  	      
                                                   ����                                 ����            	      
                                             ����	            	            
                                                   ����	            	            
                                           conn_count             conns                                                                                      node_paths              editable_instances              version             RSRC    extends CharacterBody3D

@onready var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var chat : Control
@export var max_rot_speed : float = 1000
@export var rot_drag : float = 1.05
@export var pitch_sens : float = 1
@export var thrust : float = 2
@export var expo : float = 1

@export var pitch_curve := Curve.new()
@export var roll_curve := Curve.new()
@export var yaw_curve := Curve.new()

@export var camera_limit = 15

@onready var save_path = "user://drone1_profile"

var current_camera = 0
var frame = 0
var username = ""
var peers = []

var camera_angle = 0

var speed_limit = 140
var game_multiplayer
var color : Color

var rotation_vel = Vector3.ZERO

const colors = [Color.DODGER_BLUE, Color.RED, Color.GREEN, Color.YELLOW, Color.TEAL, Color.PURPLE, Color.HOT_PINK, Color.DARK_VIOLET, Color.ORANGE_RED, Color.CRIMSON]

func _ready():
	get_parent().get_parent().request_multiplayer
	if chat: chat.chat_message_sent.connect(recieve_message)
	_on_defaults_pressed()
	load_settings()
	
	

func recieve_message(username, message, pcol):
	for peer in peers:
		if peer in multiplayer.get_peers():
			player_chat.rpc_id(peer, username, message, pcol)

func _physics_process(delta):
	if not is_multiplayer_authority(): 
		return
	if  PackedInt32Array(peers) == PackedInt32Array([]): peers = get_parent().get_parent().request_peers(self)
	if chat:
		if not chat.username == username: chat.username = username
		
	
	if color == Color(0, 0, 0, 1):
		color = colors.pick_random()
		recieve_message(username, "Joined the Game!", color)
	
	%Username.modulate = color
	frame += 1
	if frame == 5:
		
		%PitchCurve.update(pitch_curve)
		%YawCurve.update(yaw_curve)
		%RollCurve.update(roll_curve)
		
		peers = multiplayer.get_peers()
		for peer in peers:
			if not peer == multiplayer.get_unique_id():
				player_sync.rpc_id(peer, multiplayer.get_unique_id(), {"gpos": global_position, "grot": global_rotation, "color": color.to_html(true)})
				#push_error(multiplayer.get_unique_id())
				
				
				
		frame = 0
	
	if not is_on_floor(): velocity.y -= gravity * delta * 4
	
	current_camera = wrapi(current_camera, 0, $Cameras.get_children().size() )
	for c in $Cameras.get_children():
		c.current = c == $Cameras.get_children()[current_camera]
	move_and_slide()
	var input_axis1 : Vector2
	var input_axis2 : Vector2
	if get_window().has_focus():
		if Input.is_action_just_pressed("vsync"): 
			if DisplayServer.window_get_vsync_mode(0) == DisplayServer.VSYNC_ENABLED: DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
			elif DisplayServer.window_get_vsync_mode(0) == DisplayServer.VSYNC_DISABLED: DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		
		
		input_axis1.x = snapped(Input.get_joy_axis(0, JOY_AXIS_LEFT_X), 0.1) 
		input_axis1.y = snapped(Input.get_joy_axis(0, JOY_AXIS_LEFT_Y), 0.1)
		
		input_axis2.x = snapped(Input.get_joy_axis(0, JOY_AXIS_RIGHT_X), 0.1)
		input_axis2.y = snapped(Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y), 0.1)
		
		if Input.is_action_just_pressed("CameraSwitch"): current_camera += 1
		if Input.is_action_just_pressed("ResetPosition"): 
			position = Vector3.ZERO
			rotation = Vector3.ZERO
			velocity = Vector3.ZERO
			rotation_vel = Vector3.ZERO
	
	
	if input_axis1.y < 0: velocity += basis.y * -input_axis1.y * thrust
	
	var pitch_rate = pitch_curve.sample(abs(input_axis2.y))
	var yaw_rate = yaw_curve.sample(abs(input_axis1.x))
	var roll_rate = roll_curve.sample(abs(input_axis2.x))
	
	rotation_vel += (Vector3(input_axis2.y * pitch_rate, input_axis1.x * yaw_rate, input_axis2.x * roll_rate)) * pitch_sens * delta
	
	#global_rotation.x += deg_to_rad(input_axis2.y) * 2
	rotate_object_local(Vector3(1, 0, 0), deg_to_rad(rotation_vel.x) * delta)
	rotate_object_local(-Vector3(0, 0, 1), deg_to_rad(rotation_vel.z) * delta)
	rotate_object_local(-Vector3(0, 1, 0), deg_to_rad(rotation_vel.y) * delta)
	
	rotation_vel.x /= rot_drag
	rotation_vel.y /= rot_drag
	rotation_vel.z /= rot_drag
	
	rotation_vel.x = clamp(rotation_vel.x, -max_rot_speed, max_rot_speed)
	rotation_vel.y = clamp(rotation_vel.y, -max_rot_speed, max_rot_speed)
	rotation_vel.z = clamp(rotation_vel.z, -max_rot_speed, max_rot_speed)
	
	#rotate_object_local(Vector3(1, 0, 0), deg_to_rad(input_axis2.y) * 2)
	#rotate_object_local(-Vector3(0, 0, 1), deg_to_rad(input_axis2.x) * 2)
	#rotate_object_local(-Vector3(0, 1, 0), deg_to_rad(input_axis1.x) * 2)
	
	if Input.is_action_pressed("cameratilt_up"): camera_angle += 0.5
	if Input.is_action_pressed("cameratilt_down"): camera_angle -= 0.5
	if Input.is_action_pressed("cameratilt_reset"): camera_angle = 0
	
	camera_angle = clamp(camera_angle, -camera_limit, camera_limit)
	$Cameras/FP.rotation_degrees.x = camera_angle
	
	%CamRotation.text = str("Camera: %s°" % camera_angle)
	%DroneSpeed.text = str("%skm/h" % snapped(velocity.length() * 3.6, 0.1))
	%FPS.text = str("%s FPS" % snapped(Engine.get_frames_per_second(), 0.1))
	if %TelemetryVbox.size.y > 62:
		for c in %TelemetryVbox.get_children(): 
			if c is Label: 
				c.label_settings.font_size = (%TelemetryVbox.size.y / %TelemetryVbox.get_child_count()) - (%TelemetryVbox.get_child_count() * 3)
		%TelemetryVbox.size.y = clamp(%TelemetryVbox.size.y, 62, 160)
	
	#$Mesh.rotation = Vector3(input_axis2.y * 0.25, 0, -input_axis2.x * 0.25)
	
	if not input_axis1: velocity.x *= 0.75
	
	if not input_axis1: velocity.z *= 0.75
	
	velocity.x = clamp(velocity.x, -140, 140)
	velocity.y = clamp(velocity.y, -140, 140)
	velocity.z = clamp(velocity.z, -140, 140)
	
	%"Left Stick".position = %"Left Stick".size + input_axis1 * 30
	%"Right Stick".position = Vector2(%StickPanel.size.x, %"Left Stick".size.y) - Vector2(%"Right Stick".size.x * 2, 0) + input_axis2 * 30
	
	%PerfDisplay.text = str("pitch rate: ", pitch_rate)
	
	if Input.is_action_just_pressed("showsettings"):
		$ui/Settings.visible = not $ui/Settings.visible

func set_username(un):
	%Username.set_text(str(un))


func set_id(id):
	self.name = str(id)
	self.set_name(str(id))
	self.set_multiplayer_authority(id)
	#$CollisionShape3D.disabled = true
	
	if is_multiplayer_authority():
		%Collision.set_disabled(false)
		print(%Collision.disabled)
		%PerfDisplay.visible = true
		$ui.visible = true

@rpc func player_sync(player_id, sync_data : Dictionary):
	if player_id == get_multiplayer_authority():
		var tween = create_tween()
		tween.tween_property(self, "global_position", sync_data.get("gpos"), 0.1)
		tween.tween_property(self, "global_rotation", sync_data.get("grot"), 0.1)
		color = sync_data.get("color")
		%Username.modulate = color

@rpc("any_peer") func player_chat(username, message, pcol):
	printt(multiplayer.get_remote_sender_id(), "sent", username, message, "to", multiplayer.get_unique_id())
	for c in get_parent().get_children():
		if not c == self:
			if c.chat: 
				c.chat.chat_message_recieved(username, message, pcol)


func _on_speed_text_changed(new_text):
	speed_limit = str(new_text).to_float()

func _on_thrust_text_changed(new_text):
	thrust = str(new_text).to_float()

func _on_rotation_speed_text_changed(new_text):
	max_rot_speed = str(new_text).to_float()

func _on_rotation_drag_text_changed(new_text):
	rot_drag = str(new_text).to_float()

func _on_cam_angle_text_changed(new_text):
	camera_limit = str(new_text).to_float()

func _on_rotation_sensitivity_text_changed(new_text):
	pitch_sens = str(new_text).to_float()

func _on_defaults_pressed():
	thrust = 2
	max_rot_speed = 6
	rot_drag = 1.05
	pitch_sens = 1
	camera_limit = 45
	speed_limit = 140
	setting_update()

func setting_update():
	%Speed.text = str(speed_limit)
	%Thrust.text = str(thrust)
	%RotationSpeed.text = str(max_rot_speed)
	%RotationDrag.text = str(rot_drag)
	%CamAngle.text = str(camera_limit)

func load_settings():
	if not FileAccess.file_exists(save_path): return
	var properties = get_property_list()
	var save_file = FileAccess.open(save_path, FileAccess.READ)
	var save_data = save_file.get_var(true)
	save_file.close()
	print(save_data)
	for property in properties:
		if save_data.has(property.get("name")):
			set(property.get("name"), save_data.get(property.get("name")))
			await(get_tree().process_frame)
	setting_update()

func _on_save_pressed():
	var settings = {"thrust": thrust, "max_rot_speed": max_rot_speed, "rot_drag": rot_drag, "pitch_sens": pitch_sens, "camera_limit": camera_limit, "speed_limit": speed_limit, }
	var save_file = FileAccess.open(save_path, FileAccess.WRITE)
	save_file.store_var(settings, true)
	save_file.close()

func _on_load_pressed():
	load_settings()
            RSRC                    PackedScene            ��������                                            �      ui    Chat    ..    resource_local_to_scene    resource_name 
   min_value 
   max_value    bake_resolution    _data    point_count    script    render_priority 
   next_pass    transparency    blend_mode 
   cull_mode    depth_draw_mode    no_depth_test    shading_mode    diffuse_mode    specular_mode    disable_ambient_light    disable_fog    vertex_color_use_as_albedo    vertex_color_is_srgb    albedo_color    albedo_texture    albedo_texture_force_srgb    albedo_texture_msdf 	   metallic    metallic_specular    metallic_texture    metallic_texture_channel 
   roughness    roughness_texture    roughness_texture_channel    emission_enabled 	   emission    emission_energy_multiplier    emission_operator    emission_on_uv2    emission_texture    normal_enabled    normal_scale    normal_texture    rim_enabled    rim 	   rim_tint    rim_texture    clearcoat_enabled 
   clearcoat    clearcoat_roughness    clearcoat_texture    anisotropy_enabled    anisotropy    anisotropy_flowmap    ao_enabled    ao_light_affect    ao_texture 
   ao_on_uv2    ao_texture_channel    heightmap_enabled    heightmap_scale    heightmap_deep_parallax    heightmap_flip_tangent    heightmap_flip_binormal    heightmap_texture    heightmap_flip_texture    subsurf_scatter_enabled    subsurf_scatter_strength    subsurf_scatter_skin_mode    subsurf_scatter_texture &   subsurf_scatter_transmittance_enabled $   subsurf_scatter_transmittance_color &   subsurf_scatter_transmittance_texture $   subsurf_scatter_transmittance_depth $   subsurf_scatter_transmittance_boost    backlight_enabled 
   backlight    backlight_texture    refraction_enabled    refraction_scale    refraction_texture    refraction_texture_channel    detail_enabled    detail_mask    detail_blend_mode    detail_uv_layer    detail_albedo    detail_normal 
   uv1_scale    uv1_offset    uv1_triplanar    uv1_triplanar_sharpness    uv1_world_triplanar 
   uv2_scale    uv2_offset    uv2_triplanar    uv2_triplanar_sharpness    uv2_world_triplanar    texture_filter    texture_repeat    disable_receive_shadows    shadow_to_opacity    billboard_mode    billboard_keep_scale    grow    grow_amount    fixed_size    use_point_size    point_size    use_particle_trails    proximity_fade_enabled    proximity_fade_distance    msdf_pixel_range    msdf_outline_size    distance_fade_mode    distance_fade_min_distance    distance_fade_max_distance    lightmap_size_hint    _blend_shape_names 
   _surfaces    blend_shape_mode    custom_aabb    shadow_mesh    custom_solver_bias    margin    points    content_margin_left    content_margin_top    content_margin_right    content_margin_bottom 	   bg_color    draw_center    skew    border_width_left    border_width_top    border_width_right    border_width_bottom    border_color    border_blend    corner_radius_top_left    corner_radius_top_right    corner_radius_bottom_right    corner_radius_bottom_left    corner_detail    expand_margin_left    expand_margin_top    expand_margin_right    expand_margin_bottom    shadow_color    shadow_size    shadow_offset    anti_aliasing    anti_aliasing_size    line_spacing    font 
   font_size    font_color    outline_size    outline_color 	   _bundled       Script    res://Game/Objects/Drone.gd ��������	   FontFile    res://Kenney Future Narrow.ttf ��G�	   FontFile    res://Kenney Future.ttf ���:Ya   PackedScene    res://Game/Objects/Chat.tscn |VxU�VE   PackedScene )   res://Game/Objects/curve_visualizer.tscn x��H�9	
      local://Curve_h87gd          local://Curve_3qi1m �         local://Curve_8uu8b =      !   local://StandardMaterial3D_4yjn2 �         local://ArrayMesh_2nnbd 
      #   local://ConvexPolygonShape3D_1udij �         local://StyleBoxFlat_fdbuq a�         local://StyleBoxFlat_2otwl �         local://LabelSettings_5rhlo s�         local://PackedScene_wj7us ��         Curve            �D      
   
   6p�;h=          \8�?              
     �?  �?   �{@                     	         
         Curve            �D      
   
   z�;ƕ<          ���=              
     �?  �?   �'D@                     	         
         Curve            �D      
   
                                       
     �?/�?   �'�?                     	         
         StandardMaterial3D                        �?
      
   ArrayMesh    y            
         format (           
   primitive             vertex_data    _  q9,v���Tn9,����Tn]]����q]]v����s9,����q9,v���q]]v����s]]����q9,����s9,�����s]]����q]]���Tn9,����q9,���q]]���Tn]]���߭i]]5���wl]]����wl{�����i{5���wl]]���߭i]]5��߭i{5���wl{����Bo]]5���wl]]����wl{����Bo{5���wl]]����Bo]]5���Bo{5���wl{�����x9,=�T�q9,v�T��s9,��T�p�9,=�T��9,��T���9,v�Tռ�9,=�Tՙ�9,��T�em9,��T�Tn9,��T�Bo9,=�T�em9,X�T�q9,�T���9,�Tժ�9,��Tՙ�9,X�T��9,��Tը{9,"�TՔ}9,��TՔ}9,"�T�V�9,"�T�j�9,��T�j�9,"�T�p�{=����x{=���G|{������{������{������{=�����{����Bo{=���em{����em{����j�9,"���V�9,"�����O'����j��'����!�O'�����}�'�����}O'����G|O'�����}9,"����{9,"�����O'���V�9,"��p�9,=��p�{=�㲷�{���Bo{=̐�em{�ʐ�em9,�ʐ�Bo9,=̐�em9,����em{����em{����em9,X���em{X���em{X�����{X�����9,X���em9,X�����9,X�����{X�����{������9,������{������9,�ʐ���{�ʐ���{=̐���9,=̐�G|O'�� ��}O'�� ���"�� �G|{�� ���{�� ���O'�� �!�O'�� ��x9,=�㲨{9,"��G|O'��㲎x{=��G|{��㲔}9,"��Ŕ}9,���Ŕ}��\��Ŕ}{~?��Ŕ}�'�����}O'��%��}�'��%��}{~?�%���{0�%���"��%�!�O'��%���"��%���{0�%�j�{~?�%�j��'��%����0�������d�����a������M�����\z��d���\za�����j���\�����+�����@������M�j����}��\�����{����j�{~?�����t������{0����}{~?���\z{����\z+������+���Ţ�{���Ţ�a����Ţ���d��Ţ�{��%���t��%��M���%���a���%���t��%�\z{��%�\za���%��M���%�\z{����\z+����\z��d���\za�����\z+��R��@���R����0�R�\z��d�R��@���R종+��R종��d�R����0�R�j���\���j�9,����j�9,"���j�{~?���j��'���Ŕ}9,��R��9,��R��M�j�R�}��\�R��M�j�R��9,��R�j�9,��R�j���\�R��9,������9,�����]]����]]������9,v����9,�����]]������]]v���wl{��T�Bo{5�T�em{6�Tխi{5�T��g{��T�em{.lTխi{]T�em{�hT�wl{�_T�Bo{]T�q{�hT�q{'<T���{'<TՔs{�*T�j�{�*T���{@#T�L�{�!Tՙ�{�TՓ�{�T�S�{�T�~�{�T�em{3�T�wl{��T�em{��T�q{.lT�q{��T���{.lT���{��Tՙ�{.lTՙ�{��T�-�{��Tՙ�{3�Tՙ�{6�T���{3�T�q{3�TՉk{�?T�wl{eZT��g{'<T�em{�?Tՙ�{ɿTՙ�{X�T�Ȓ{x�Tՙ�{��T�em{X�T�em{ɿT�em{��T�6m{x�T�Q�{]T�-�{'<T�u�{�?TՇ�{eZTՙ�{�?Tռ�{]T���{�hTղv{�!T�kz{�T�em{�Tիi{�TՀi{�T�q{@#Tՙ�{�hTՇ�{�_TՀi{���em{���em]]����i]]���q]]@#��em]]���em{���q{@#��q{@#��q{'<��q]]'<��q]]@#���g]]'<���k]]�?���k{�?���g{'<��em]]�?��q]]'<��q{'<��em{�?��em{�? ��k{�? ��k]]�? �em]]�? ��i]]]��wl]]�_��wl{�_���i{]��wl]]eZ�߭i]]]�߭i{]��wl{eZ��Bo]]]��wl]]eZ��wl{eZ��Bo{]��wl]]�_��Bo]]]��Bo{]��wl{�_��em{6�����{6�����9,6���em9,6�����{6�����{ɿ����9,ɿ����9,6�����{ɿ �em{ɿ �em9,ɿ ���9,ɿ �em{ɿ��em{6���em9,6���em9,ɿ��em9,ɿT�em9,6�Tՙ�9,6�Tՙ�9,ɿT�~�]]�����]]�����{���~�{�����]]�����]]@#����{@#�ߙ�{�����{'<����{@#����]]@#����]]'<��u�]]�?��-�]]'<��-�{'<��u�{�?����]]'<����]]�?����{�?����{'<����]]�? �u�]]�? �u�{�? ���{�? ��'M�08�j�{�*8��s{�*8��r'M�08��r��*8����*8��vcV.28�L�cV.28�L�{�!*�j�{�**����**�L�%M!*��a'�"*Ѳv{�!��L�{�!��L�%M!���v%M!���r��**єs{�**Ѳv{�!*Ѳv%M!*��ra'�"*��r'M�0���r��*���ra'�"���r�U�(��L�cV.2��L��^�)����U�(���'M�0���v�^�)ƱL��^�)ƱL�cV.2Ʊ�vcV.2Ʊ�r�U�(���v�^�)���vcV.2���r'M�0����2W[����]? ��ly2W[���v�F4��L��F4��ly�6�����6����/)����/)��ly�6��ly$.i#���a'�"�򒆌6����/)���a'�"��$.i#��L��F4~ْ��6~ْ�$.i#~�L�x>�%~ْ�2W[��L��F4��L�x>�%���N�'����U�(���a'�"�����*���'M�0�Ͳv�F4��ly2W[��ly�N�'�²vx>�%��ly�6~ٲv�F4~ٲvx>�%~�ly$.i#~���]? ����2W[�����N�'����U�(��ly2W[����]? ����U�(��ly�N�'����$.i#��L�%M!���a'�"��L�x>�%����U�(�����N�'��L��^�)����U�(���v�^�)��ly�N�'���r�U�(���vx>�%���ra'�"��ly$.i#���v%M!���a'�"������iD���BYD��  BYD��  jzD�����iD�囑jzD���BYD���BYD����)���������������囑jz���  jz�Á��)����  ����������}b��iD��`�BYD��`�BYD�d�jzD�d  jzD�}b��iD��`  BYD��`�BYD�}b�)����`������`  ����d  jz��}b�)���d�jz���`������`�����-��RT���BYT�囑jzT�-����T�����T�Ɩ�E�T�Ɩ�E��Ɩ�E��Ȓ�x��Ȓ{x��-�{���-�����d�jzT��g�RT��g���T��`���T�8i�E�T��`�BYT�em{����Bo{=���Bo�=���6m�x���6m{x����g�y!T��g�RT�]i�gPT�kz��TՓ���Tիi��T�-��y!T�S���Tա��gPT�-��RT�6m�x��8i�E��8i�E��6m{x���g{����g�����g{�����g������g�R���g{'<���g�R���g�y!���g]]'<���g�ny!���g�n�`���g1g�`���g]]�����g1g�������=� ��x{=� �p�{=� ���{=� �p�9,=� ���9,=� �Bo9,=� ��x9,=� �Bo{=� �Bo�=� ��i���ݫi{��݀i{����g�y!�݀i]]����g�ny!�ݫi�n��ݫi]]��ݫi����kz����kz{����i{���kz������������{���kz{������=�����{=�����{����Ȓ�x���Ȓ{x���-�{'<��-��R��-��R��-�{����-������-��y!��-�]]'<��-��ny!��-��n�`��-�1g�`��-�]]����-�1g����~�{���S�����-��y!��~�]]���-��ny!��S��n���S�]]���S�{��ݓ�����S�����S�{�����{���]i�l�T�8i�E�T�6m�x�T�Ȓ�x�T�Bo�=�Tռ��=�Tա��l�T�Ɩ�E�T�]i�l� ����l� ���  l� �]i  l� �����ܡ����ܡ��ƟܡƖ�E�ܡƖ�E�ܡ��  l�ܡ���l�ܡ��Ɵܡ�  ��ܡ����ܡ�  jzT��  BYTա�  gPT�]i  gPT�d  jzT��`  BYTա�  l�T��  ��T�]i  l�T��`  ��T�]i  gP����  gP�����gP��]i�gP���  BY!���BY!���U!ޡ�  gP!�-��R!ޡ��gP!���U!�-��R!���BY!���BY!��`  ��ܡ�`���ܡ�d�Ɵܡ]i  l�ܡ8i�E�ܡ]i�l�ܡ�d�Ɵܡ8i�E�ܡ�`���ܡ�`���ܡ�`�BY!��`�BY!��d�U!��g�R!��g�R!�]i  gP!�]i�gP!��d�U!��`  BY!��`�BY!��ק�����U����U�����������������Ɵ����Ɵ���ק����$(�����d�U���d�U��$(�����`�BY���d�U��$(����%�d&�������J����>����}b��i����'��U�}�� �6��� ���� ����  �h�������-������ ����� ����  ���)���$(������d�Ɵ���`�����%�o���}b�)���������)�������)���J�P�������U�V��� ������ �T���� �����  �k���-�������3���������������>�J�����������Ɵ������������o���t��)������P������J������)������������V����������V��T������������k���)������������J��3���������m������z������$(������d�Ɵ���d�Ɵ��$(������ק��T���ƟT�����T���o�TՁ��)�T�)��T�z֧��T�t�)�Tմ�P�T����Tթ�V�T������T�V��T�T�����T����k�T�����T�J�3�T����T�m���T���J�T��`���T��d�ƟT�$(���T�%�o�TՊ�)�T�J�P�T�>�J�T�}b�)�T���T�U�V�T� ���Tը �T�T�� ���T�  �k�T����T�-���Tմ�3�T�����TՑ���TՄ)���T�$(��T��d�UT��`�BYT�%�d&T�}b��iT����TՄ)�TՊ��T�J��T���'T�U�}T� �6Tը �T�� ��T�  �hT�-�Tմ�� T���� TՑ�  T�>��T���BYT���UT��ק�T���d&T�t��Tմ��T����TՁ���iT����'Tթ�}T����6T�V��T����T����hT�)��T���T�J�� T��� T�m�  T�z֧T� ���e�� ���e�� ���e� ���e�  �k���� ������ �����  �k���  �k�Tը �T�Tը �T�T�  �k�T�U�V���� �T���� �T���U�V�����3�T�����T�����T���3�T�����������������������������-���-�����������U�V���U�V�������J�P��� ����� �����J�P���J�P���>�J���>�J���J�P���>�J�����)�����)���>�J�����)���-�����-�������)����������3�����3��������������)������)�����������)�����$(�����$(������)�����%�o�����������%�o���%�o���}b�)���}b�)���%�o������6���������������6�����h���������������h�����h��V����V�������h����}��V����V�������}��J��� ��m��  ��m�  ��J�� ���� ��m�  ��m��  ����� ����� d����d���d��� d����'����}�����}������'�����������6�����6����������������������������������t����t�����������t�������������t�����)�����J��� ��J�� ��)����)����z֧��z����)�����z֧���ק���������z������d&�����'������'�����d&�����d&������i������i����d&����������U����BY�����d&������i��)�����z����t���������������'�����}�����6��V������������h�������J��� ����� ��m��  ����������o������)������)������o���%�d&��}b��i��}b��i��%�d&��-�d���� d���� d�-�dؑ�  ����� ����� ����  ����  ���� ���� ���  ���������� ����� �������� ���  �h��  �h��� ���� ����  �h��  �h��� ����� ���� �6�� �6��� ����)��������������)��������-���-�������������>����>���������>����J����J����>����J���� �6�� �6��J����U�}��� ���� ���U�}��U�}����'����'��U�}����'��%�d&��%�d&����'��$(�����)����)���$(��������������������m����������������m������m����T�J��3�T�J�3�T�m���T�)����J�3���J��3���)�����V��T�T����k�T����k�T�V��T�T����������k������k�������������e������e������e�����e�z֧����)����)�����z������t��)����������������t�)���t�)�����J������J���t��)�����J�����P������P������J�����P��������������������P������V���V��T���V��T�����V�����V�����������������V����������o������o����������ק����z֧����z����������������.eTՙ��.�hT����.�hT�wl�.eT�q�.�hT�em�.�hTխi�.�gT�em�..lTխi�.�T�em�.��T�em�.3�T�wl�.T�q�.3�T����.3�T����.��T�Q��.�gTՙ��..lT�Q��.�Tՙ��.��Tՙ��.3�T����..lT�q�.��T�q�..lTՇ��.T�em�.�h��q�.�h��q�:�h��em�:�h��em�..l��em�.�h��em�:�h��em�:.l��q�.����q�.3���q�:3���q�:����em�.����q�.����q�:����em�:�������.3������.�������:�������:3������.3� ����.3� ����:3� ����:3� ����.�h�����.�h�����:�h�����:�h�����..l�����.�h�����:�h�����:.l�����:eT����:�hTՙ��:�hT�Q��:�gTՙ��:.lT�Q��:�Tՙ��:��Tՙ��:3�TՇ��:T����:3�T�wl�:T�q�:3�T�em�:3�Tխi�:�T�em�:��T�em�:.lT�q�:��T�q�:.lT����:��T����:.lT�q�:�hT�wl�:eTխi�:�gT�em�:�hT�wl�:e�����:e����@Ge��wl@Ge���i�:�g��wl�:e��wl@Ge�߭i@G�g�߭i�:����i�:�g���i@G�g���i@G���wl�:���i�:����i@G���wl@G����e" �wle" �wl�. ����. ����: �wl�: �wl@G ���@G �wle"e����e"e�����.e��wl�.e��wle"���ie"����i�.���wl�.��qe"3�����e"3�����e"����qe"������e".l��qe".l����e"�h��qe"�h����e"e��wle"e��eme"�h���ie"�g��eme".l���ie"���eme"����eme"3�����e"����e"3���wle"��Q�e"�����e"������e".l����e"�h��Q�e"�g���ie"����ie"�g���i�.�g���i�.����ie"�g��wle"e��wl�.e�߭i�.�g��q�N��T�q�N3�T�em�N3�T�em�N��T�q@G����q@G3���q�N3���q�N����em@G����q@G����q�N����em�N����em�N.lT�em�N�hT�q�N�hT�q�N.lT�em@G�h��q@G�h��q�N�h��em�N�h��em@G.l��em@G�h��em�N�h��em�N.l��q�.3� �em�.3� �em�:3� �q�:3� �em�.3���em�.����em�:����em�:3���q�.�h��q�..l��q�:.l��q�:�h��q�..l �em�..l �em�:.l �q�:.l �q@G�h��q@G.l��q�N.l��q�N�h��q@G.l �em@G.l �em�N.l �q�N.l �q@G3� �em@G3� �em�N3� �q�N3� �em@G3���em@G����em�N����em�N3���q@G3�T���@G��T���@G3�T�wl@GTՇ�@GTՙ�@G.lTՙ�@G��T���@G.lT�q@G��T�q@G.lT�em@G��T�em@G.lTխi@G�Tխi@G�gT�em@G�hT�wl@GeT�q@G�hT���@G�hT�Q�@G�Tՙ�@G3�TՇ�@GeTՙ�@G�hT�Q�@G�gT�em@G3�T�qe"����eme"����em{����q{����qe"3���qe"����q{����q{3���eme"����eme"3���em{3���em{����eme"3� �qe"3� �q{3� �em{3� �eme"�h��eme".l��em{.l��em{�h��qe"�h��eme"�h��em{�h��q{�h��eme".l �qe".l �q{.l �em{.l �qe".l��qe"�h��q{�h��q{.l��Q�e"�����e"�����.��Q��.���Q��.���Q��.�g��Q�e"�g��Q�e"�����e"e��Q�e"�g��Q��.�g�߇��.e��Q��:������:����@G��Q�@G���Q��:�g��Q��:���Q�@G���Q�@G�g�����:e��Q��:�g��Q�@G�g�߇�@Ge�����N3�T����N��Tՙ��N��Tՙ��N3�T���@G3�����@G�������N�������N3�����@G������@G�������N�������N�������N.lT����N�hTՙ��N�hTՙ��N.lT���@G�h����@G�h�����N�h�����N�h����@G�h����@G.l�����N.l�����N�h�����.�������.3������:3������:�������..l ����..l ����:.l ����:.l ���@G.l����@G�h�����N�h�����N.l����@G.l ���@G.l ����N.l ����N.l ���@G3� ���@G3� ����N3� ����N3� ���@G������@G3������N3������N�������.�������.�������:�������:������e"������e"������{������{������e"������e"3�����{3�����{������e"3�����e"������{������{3�����e"3� ���e"3� ���{3� ���{3� ����.�h�����..l�����:.l�����:�h����e".l����e"�h����{�h����{.l����e"�h����e"�h����{�h����{�h����e".l ���e".l ���{.l ���{.l ���e"�h����e".l����{.l����{�h���l1g����k1gs����k1g���u�1gs���W�1g���u�1g����iе�?��k���?��kе��?��k1g�?��il�?��kl��?��kе�f��k���h��iе�h��u����?�Q�е�?�u�е��?��k�����u������u�е�����kе�����kl�f��il�h��k1g�h��u�l��?�Q�l�?�u�1g�?��l1g����k1g����kl����W�1g���u�l����u�1g���u�е�f��Q�е�h��u����h��kе�f��u�е�f��u����h���k���h��Q�е�h��Q�е���u������u����h��u�1g�h��Q�l�h��u�l�f��u�l�f���kl�f���k1g�h��u�1g�h��Q�е�h��u�е�f��u�l�f��Q�l�h��Q�l�h��u�1g�h��u�1gs���Q�l���u�1g���u�е����Q�е���Q�l���u�l�����k1gs��ŉk1g�h�ŭil�h�ŭil��ŉk1g��ŉkе�f�߭iе�h�߭il�h�߉kl�f�߉k���h�ŉk����ŭiе��ŭiе�h�ŭiе����kе�����kl�����il���u�l�� ��kl�� ��kе�� �u�е�� ��k���TՉk���hT�u����hT�u����T�Q�е���Q�е�h��Q�l�h��Q�l����kl�f��u�l�f��u�е�f���kе�f���il����il�h���iе�h���iе���-�1g��T�u�1gs�T�u�1g�hT�-�1g�`T�u�1g-dT��1g-dTՉk1g�hT��s1g-dTՉk1g-dTռ�1g[cT�Bu1g[cTշ�1g�\T�G~1g�\T�|�1g#_T��1gvaTՂx1g#_T�v1gvaT��g1g�`T��g1g��TՉk1gs�Tէl1g�T�W�1g�T�Ȓ1gx�T�6m1gx�T�Bo1g=�Tռ�1g=�T��]]��T��s]]��T�q]]v�T���]]v�T�Bo]]=�Tռ�]]=�Tժ�]]��T�Ȓ]]x�T�-�]]��T���]]�T�Bo]]5�T�q]]�T�wl]]��T�Tn]]��T��g]]��T�6m]]x�Tխi]]5�Tխi]]]T�wl]]��T�wl]]�_T�Bo]]]Tռ�]]]TՂ�]]B3T�&�]]�2Tիi]]�TՀi]]�T�em]]�T� q]]�T�q]]@#T�Ks]]a T�9v]]�0T�q]]'<T�w]]2T��w]]�2T�|y]]B3T���]]'<T��]]2T�ŉ]]�0T���]]@#Tճ�]]a T�ގ]]�Tՙ�]]�T�S�]]�T�~�]]�Tՙ�]]�?TՇ�]]eZT�u�]]�?T�Q�]]]T�-�]]'<T��g]]'<TՉk]]�?T�wl]]eZT�em]]�?TՇ�]]�_T�Bo1g=�����1g=�����]]=���Bo]]=���6m1gx���Bo1g=���Bo]]=���6m]]x����l1g��6m1gx��6m]]x�ﻉk1gs���g]]����g1g��ﻼ�1g=���Ȓ1gx���Ȓ]]x�����]]=���Ȓ]]x��Ȓ1gx��W�1g��u�1gs��-�]]���-�1g��ﻇ�]]�_��Q�]]]��Q�{]����{�_��Q�]]]�߇�]]eZ�߇�{eZ��Q�{]�߇�]]eZ�߼�]]]�߼�{]�߇�{eZ�߼�]]]����]]�_����{�_����{]��ŉ�n�06�爐n26��]]26�ŉ]]�06�爐n2y�&��n�2y�&�]]�2y��]]2y�&��n�2�񂆐nB3��]]B3��&�]]�2�񂆐nB3��|y�nB3��|y]]B3����]]B3��|y�nB3���w�n�2���w]]�2��|y]]B3���w�n�2y�w�n2y�w]]2y��w]]�2y�w�n26�9v�n�06�9v]]�06�w]]26�9v�n�0��Ks�na ��Ks]]a ��9v]]�0��Ks�na �� q�n��� q]]���Ks]]a �� q�n����i�n����i]]��� q]]���q�NL8�q�L8�Tb�L8�7c�N8����NL8�V��N8�8��L8����L8��bN��B��jyN��B���y���C��Tb���C��_>�gA��bN��B�Tb���C�^`��B�^��6<��_��e;��_>�gA��^`��B��Tb���:U��b��3:U�_��e;U�^��6<U�jy��3:���b��3:��Tb���:���y���:���y���:U�#~��6<U�}��e;U�jy��3:U�#~��6<��#~`��B��}>�gA��}��e;��}>�gA�#~`��B��y���C�jyN��B�#~��?��#~��6<���y���:���y��=��#~`��B��#~��6<��#~��?��#~z�dE��#~`��B��#~z�dE���{��F���y���C���y*��H��Tb���C���y���C���y*��H��Tb��Z��8���Z��8�*��H��jyN��B���bN��B��_>�gA��}>�gA��_��e;��}��e;���b��3:��jy��3:��^��6<��^��A��1`_�e>��Tb���:��Tb��=���y���:��Tb���:��Tb��=���y��=��Tb��=��1`_�e>��1`��|:���y��=��7c4�9��V�4�9��\���|:��#~��?��\�F�E��#~z�dE��V���F���{��F��^��A��^��6<��^`��B��^&ߝX��^/�kM��^��<��8�*��H���y*��H���{��F��V���F��1`��|:U�^��<U�Tb���:U�7c4�9U�\���|:U�V�4�9U�8����:U逢��<U�\�F�E��\���|:������<������PG��8�*��H�V���F�\�F�E瀢��PG�1`_�e>��^��A��^��<��1`��|:��Tb���:��8����:��V�4�9��7c4�9��Tb�L��Tb���:��^��<��^/�kM��Tb�L8�q�L8�q3�y;8�Tb���:8���3�y;8�8����:8�8��L8����L8΀�/�kM�ˀ���<��8����:��8��L��1`s��O	�7c�N	�Tb�L	�^/�kM	�1`�?Zݢ1`s��Oݢ^/�kMݢ^&ߝXݢTb��Z�7c��<[�1`�?Z�^&ߝX�V���<[Ƒ7c��<[ƑTb��ZƑ8���ZƑ8���Z���&ߝX�\��?Z�V���<[�\��?Zݢ��&ߝXݢ��/�kMݢ\�s��Oݢ\�s��O	���/�kM	�8��L	�V��N	�8���Z��8�*��H������PG����&ߝX������PG�݀���<�݀�/�kM�݀�&ߝX��V��N8�7c�N8�1`s��O8�\�s��O8�1`�?Z8�\��?Z8�7c��<[8�V���<[8�^&ߝX��^`��B��Tb���C��Tb��Z����3�y;��q3�y;��q�nu4�����nu4�����L����3�y;�����nu4�����n+T�����NL��q�n+T��q�NL�����NL�����n+T��S��n���ގ�n���ގ]]���S�]]���ގ�n��峌�na �峌]]a ��ގ]]��峌�na ��ŉ�n�0��ŉ]]�0�Ƴ�]]a ��q�nu4��q3�y;��q�L��q�n+T��q�NL��-��n�`T����n+TT����nu4T�-��ny!T�S��n�Tշ��n�\T�q�n+TT�|��n#_T�ꉐnvaT��g�n�`T�q�nu4TՉk�n-dT��s�n-dTՂ��nB3T�|y�nB3T��w�n�2T�ގ�n�Tճ��na T�ŉ�n�0T�爐n2T�&��n�2T�w�n2T�9v�n�0T�Ks�na T� q�n�Tիi�n�T��g�ny!T�v�nvaT�Bu�n[cTՂx�n#_T�G~�n�\T���n-dTռ��n[cT�u��n-dT��1g-d����1g[c�����n[c����n-d��ꉐnva�����n[c����1g[c���1gva���s�n-d��Bu�n[c��Bu1g[c���s1g-d��v1gva��Bu1g[c��Bu�n[c��v�nva��v�nva���x�n#_���x1g#_��v1gva��|��n#_��ꉐnva���1gva��|�1g#_�����n�\��|��n#_��|�1g#_����1g�\��G~�n�\ ����n�\ ���1g�\ �G~1g�\ �G~1g�\���x1g#_���x�n#_��G~�n�\���k�n-d ��s�n-d ��s1g-d ��k1g-d �u��n-d��-��n�`��-�1g�`��u�1g-d��u�1g-d ��1g-d ���n-d �u��n-d ��g�n�`���k�n-d���k1g-d���g1g�`����9,������9,v�����]]v�����]]������9,��ߪ�9,���ߪ�]]������]]����������������  �  �  �  �  �  �  �  �������������������������������������  �  �  �  �  �  �  �  ��������������������������������������������������������������������������������������������  �  �  �  � � � � � � ��������������������������������  �  �  �  �  ����������������������������������������  �  �  �  �  �  �  �  �  ������������������������������������ c � c � c � c � c �'==�'==�'==�'==�'==�=+�B=+�B=+�B=+�B=+�B������������������|���|���|���|����Z��|���|����Z��|����Z���Z���Z��F�F�F�F�=+�B=+�B=+�B=+�B'==�'==�'==�'==� c � c � c � c Ưv�ӯv�ӯv�ӯv���SP	�SP	�SP	�SP	F� F�F�F�F��v�ӯv�ӯv�ӯv���SP	�SP	�SP	�SP	���������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������  �  �  �  �  �  �  �  �������������  �  �  �  �������������������������������������  �  �  �  �  �  �  �  �������������  �  �  �  �����������������������������������������������������������������������������  �  �  �  ������������������������  �  �  �  �  �   �  �  ��j�2�j�2�j�2�j�2�j�2����������������yM��yM��yM��yM��yM��ʨڬʨڬʨڬʨ���#��#��#��#����������������������������������������������i�M�i�M�i�M�i�M���j:��j:��j:��j:���D���D���D���DΰkQΰkQΰkQΰkQU��JU��JU��JU��Jk�/�k�/�k�/�k�/���_���_���_���_�O�zgO�zgO�zgO�zgz篩z篩z篩z篩�������������������������������������������������  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �������������������������������������������������������������������������  �  �  �  �  �  ���������������������������������������UUTUTUTUTUTUUUTUTUTUUUTUTUUUTUUUTUTUTUTU�������������������������������������������������������������������������������������������������������������������������������������  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  TUUUTUUUUUTUTUUUUUTUTUUUUUTUUUTU�������������  �  �  �  �  �  �  �  �  �  TUTUTUTUTUUUTUUUTUTUTUTUUUTUUUTUUUTUTUTU�������������  �  �  �  �  �  �  �  �  �  ��������������������������������������������������������������|���|���|���|��Z��Z��Z��Z�������������  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �|��|��|��|��Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*Tժ*������������lH�lH�lH�lH��������������������������  �  �  �  q�q�q�q���������������|���|���|���|�����lH�lH�lH�lH�q�q�q�q���m���m���m���m�������������|��|��|��|��l��l��l��l������������|���|���|���|��  �  �  �  l��l��l��l���  �  �  �  �����������������������������  �  �  �  |��|��|��|����������l��l��l��l����������m��m��m��m��������������������|���|���|���|�lH�lH�lH�lH�q�q�q�q�|��|��|��|��  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  ��������������Z��Z��Z��Z��������������������������  �  �  �  l��l��l��l�������������������������������������������������������C��C��C��C�����������������������������<��<��<��<��q�q�q�q��Z��Z��Z��Z����������������������  �  �  �  ��������������������lH�lH�lH�lH��  �  �  �  �������������  �  �  �  �Z��Z��Z��Z���������������������������������<y�<y�<y�<y��������������������������������������������������������������������������������������������������������������������������������������������������������������������������  �  �  �  ������������������������������������������������������������TUTUTUTUTUTUTUTUTUTUTUTUTUTUTUTUTUTUTUTUTUUUTUTUTUUUTUTUTUTUTUTUTUTUTUTUTUTUTUTUTUTUUUTUUUTUUUTU������������������������������������������������������������������������������������������������  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  ������������������������������������������  �  �  �  �����������������������������������������������������������������������������  �  �  �  �������������  �  �  �  �������������������������������������������������������������������������������������������������������������������������������������������������  �  �  �  �������������������������������������������������������������  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  Tժ*Tժ*Tժ*Tժ*������������������������Tժ*Tժ*Tժ*Tժ*�������������  �  �  �  �  �  �  �  �������������������������������������������������  �  �  �  �������������������������������������  �  �  �  �������������  �  �  �  �  �  �  �  ������������������������������������  �  �  �  �  �  ��b��b��b�b=��b=��b=�П�M؟�M؟�M؜�/��/��/������������NX^�NX^�NX^��P�B�P�B�P�B  �  �  �  �  �  ����������������������������������_t�'_t�'_t�'|���|���|���|����  �  �  �   c�9 c�9 c�9 c�9 c�9�  �  �  �  F��F��F��F��F���������������� ��� ��� ��� ������������������������������������������  �  �  �  ��������������������������������������������������������������������������������������������������������������������������������TUTUTUTUTUTUTUTUTUTUUUTUUUTUUUTUTUTUTUTUTUTUTUTUTUTUTUUUTUTUTUUUTUTUTUTUTUTUTUTUTUTUTUTUTUTUUUTUUUTUUUTUTUTUTUUUTUTUTUUUUUTUTUTUTUUUTUUUUUTUTUTUUUTUTUUUUUTUUUTUUUTUUUTUTUUUTUUUTUTUTUTUTUTUTUTUTUTUTUTUTUTUTUTUTUTUTUTU���������������������������������������  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �������������������������������������������������������������������������  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  ������������  �  �  �  �  �  �  �  ��/��/��/��/Μ��՜��՜��՜��Ճxr�xr�xr�xr�h��h��h��h��9���9���9���9����qG�qG�qG�qGsf{sf{sf{sf{|��|��|��|��>X�7>X�7>X�7>X�7U��JU��JU��JU��Jg�Xg�Xg�Xg�Xg�X������������������������������������������;H>�;H>�;H>�;H>�;H>ض���������������������������������������������������P0��P0��P0��P0��P0��P0��/��/��/��/ηh��h��h��h���qG�qH�qH�qGsf{sf{sf{sf{|��|��|��|���xr�xr�xr�xr�9���9���9���9���;H>�;H>�;H>�;H>�  �  �  �  �  �  �  �  �>X�7>X�7>X�7>X�7�4v��4v��4v��4v��]���]���]���]���\��\��\��\��������������������������O"�O"�O"�O"w9'Kw9'Kw9'Kw9'Kg�Xg�Xg�Xg�X1!g/1!g/1!g/1!g/  �  �  �  �  �  �  �  �X���X���X���X����������������  �  �  �  �  ��^��^��^��^�  �  �  �  ��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������L��L��L��L��  �  �  �  D��D��D��D���  �  �  �  �������������j��j��j��j�������������;��;��;��;���������������  �  �  �  �������������������������  �  �  �  �  �  �  �        vertex_count    �        attribute_data    �  �]�7~]�7~ {� {�]�7~]�7~ {� {�]�7~]�7~ {� {�]�7~]�7~ {� {7~ {� {�<�7~<�7~ {� {�<�7~<�7~ {� {�<�7~<�7~ {� {�<�7~<�����~:�y}˚���y}���~>�����~��~z�y}���ڞ_{z�7|:�7|>�y}π_{���<�ǃ���X�ǃX�ǃr��� �ǃ �\���|�Q~N���N�g������g�}�nx��w���w}���̂���b��>�́b��>��b�(b����~�����]�P�]�P�<��<��<��<��]��]�t�]�t�<�p�<��]��<�ϐ<��<��]�ϐ]�t�]�t�<��<��]��<��]��<��<��]�������������<�\�<�\��������]�m�]�P����<�P�<�$���G��fWB�fWB��%�����fWB�fWB�������fWB�fWB�������e������s}e�s}��~�s}e�����͍��s}��~t�������t������e���<��<��������<��<��������<��<��������<��<��������<��<��������<��<������B�fWB�G����fW��B�G����fWB�fWB�fWB���G��fWǁ]��]�� {ǁ {ǁ]��]�� {ǁ {��J���ڞ}�z�������Y��{z��t��zz��uJ��tڞz:�e:�e>��\��\e�TY>��X��W��V]��W�|�W�|�z�r�J�>�z��{:�>�:��{>�>�>��{�>���� {��}���>��:��f�csJ�eY��fz�M�����Y��m����z�M�z�m�z�Y����t�|e {�f_~cs/�f��t��z>��X[��V��Wz��W���W�TY:�z��u/�<�<~<�<~ {� {�~ {/� {/�<��~<�nx<��l<��l {nx {�~ {/� {/�<��~<��~ {/� {/�<��~<�Q~<�y}<�y} {Q~ {7~ {� {�<�7~<�7~ {� {�<�7~<�7~ {� {�<�7~<�7~ {� {�<�7~<�ϐ<��<��]�ϐ]�ϐ<��<��]�ϐ]�ϐ<��<��]�ϐ]�ϐ<��<��]�ϐ]�g�z��wz��w�g��� { {<��<��~ {/� {/�<��~<�T�<���<��� {T� {�~ {/� {/�<��~<��~ {/� {/�<��~<��� {�� {��<���<������bz�z�z[��[��{ބ3�ބz�^��^�򀵌ƅ�����>���ր��րބ>�ބ���~^��z^�8z�O{��>���ր��րބ>�ބ򀵌����ƅ�	�ːրބ>�ބ>���ր��8z�O{�����}ː}������3�<��{<�����}���[���7��7�<��<���7��7�<��<���7��7�<��<���7��7�<��<�րބ>�ބ>���ր����7��7�<��<���7��7�<��<���7��7�<��<���7��7�<��<�}���{��z[��{<�z�}��{ބ��3�ބ�����3�<��[�����3����[��<���<���ܑ�ܑ�]����������]���]�3�]�3�����ܑ��<�3�ܑ3�<�x]�Cp]�Cp������ܑx<�CpܑCp<�t<��{<��{ܑlܑt]�l���{���{]��l�Tp
��хr����
�ǓJ�N�͍N�m�*tm�*t-���-���͍����lJ�r�J���P�Ǔ�TpP�|-���-���m�_m�_-�r���v�Ew�� �ܑ ��_�|�r��w_�~yEw:y�v�wԋm��ym��y͍ԋ-�Ss-�Ss͍cs-�cs͍�R͍�H-��Rm��;m��Hw�;aq�Yaq�Y�scswcs�sڕm��-���-�ڕ-���N�ڕN���N��N���-���m�_m�_-�|-���m�|w��aq_aq_wa�m��{m��{-�a�-�r�m�g�m�g�-�r�-�_m�_-���-���m���-�z�-�$�m�$�͍��-���͍�m�z�w�aq>�aq>��s��w���s��-���m�_m���w_aq��aq��w��-�8�m��|m��|-�8�-��O���Oࠖ=d��=�|�<���<_~�O:y�Oy�u]�9�]�9�ܑ�uܑԂ��Ԃ]�#�]�C}��C}]�*}ܑ*}]�#�<�ԂܑԂ<��х��
�ٓj�ٓ������P�%lj�Tp
�%l�TpP���ܑ3�ܑ3�]���]�*}ܑ*}<��<�Ԃܑˁ]�Ԃ]��]�ˁ��*}��*}]�*}ܑ*}<��<�Ԃܑ��]�Ԃ]��]�����*}��*}]�Ԃ��Ԃ]�#�]�3~��3~]�*}ܑ*}]�#�<�ԂܑԂ<���<�%�<�%�]���]��]��]��<��<��]��]��<��<��q���sX�JXk��R���P��Lq�~M��r���P�۹K�G��rF��F��&F��T9�,P#��Rl��P'�(R���X��JX9�s!n�q�q�R�C�r�T@+�X�4�P�,�L5�P�D�Kg;G�3rF�8�F�4&F�7,PV"�R!�PR!(Rz ~M�.��q;�!n��9 ��C4��,c�5���.U��q��DE�g;��3���8i��4ع�7�@+үV"R�!v�R!֭z ��4��<�%�<�%�]���]��R��WnߧTp`�JXk�x ��K�P�ۛLq��P���X��T9�,P#��Rl��P'�(R��G��rF��F��&F��~M��TpuWn�x�R�CJX9�L5�P�,~M�.xyv�X�4T@+,PV"�R!�PR!(Rz �Kg;G�3rF�8�F�4&F�7�P�D ��C���x��u��9�yvE�g;q��Dc�54��,��4�@+үV"R�!v�R!֭z ��3���8i��4ع�7���.��`���ߧ ��ܴ�k�c�q�4������ �����9�ү#�R�l�v�'�֭��E��⸡쌹��i���ع��q���Q�����<�Q�<��<�k�<�k�]��]�K�����<�K�<��<�k�<�k�]��]�K�����<�K�<��<�k�<�k�]��]�Q�����<�Q�<�ӆ<��<��]�ӆ]��]���]���<��<�i�<��<��]�i�]�i�<��<��]�i�]��<�k�<�k�]��]��]�v�]�v�<��<�ӆ<��<��]�ӆ]��<�{�<�{�]��]�e�<��<��]�e�]��]���]���<��<�Q�����<�Q�<��<�k�<�k�]��]�K�����<�K�<��<�k�<�k�]��]�K�����<�K�<��<�k�<�k�]��]�Q�����<�Q�<�ӆ<��<��]�ӆ]��]���]���<��<�i�<��<��]�i�]�i�<��<��]�i�]��<�k�<�k�]��]��]�v�]�v�<��<�ӆ<��<��]�ӆ]��<�{�<�{�]��]�e�<��<��]�e�]��]���]���<��<���k�;�X���� ���U����9����4���c�q�q���E��⸡쌹��i���ع��ү#�R�l�v�'�֭��������<�	�<�	�]���]���<�	�<�	�]���]�Q�����<�Q�<��<�k�<�k�]��]�K�����<�K�<��<�k�<�k�]��]�K�����<�K�<��<�k�<�k�]��]�Q�����<�Q�<�ӆ<��<��]�ӆ]��]���]���<��<�i�<��<��]�i�]�i�<��<��]�i�]��<�k�<�k�]��]��]�v�]�v�<��<�ӆ<��<��]�ӆ]��<�{�<�{�]��]�e�<��<��]�e�]�Q�����<�Q�<��<�k�<�k�]��]�K�����<�K�<��<�k�<�k�]��]�K�����<�K�<��<�k�<�k�]��]�Q�����<�Q�<�ӆ<��<��]�ӆ]��]���]���<��<�i�<��<��]�i�]�i�<��<��]�i�]��<�k�<�k�]��]��]�v�]�v�<��<�ӆ<��<��]�ӆ]��<�{�<�{�]��]�e�<��<��]�e�]��u/�w��w>��uJ��w:��wz�+w��Eyz�ӈ����z�g�z��J�g�:�g�>���>�+w�|Ey�ӈ�|���g��Ey>���:�Ey:��/��������~���~���������~���~���������~���~���������~���~����Q~��Q~~��~����Q~��Q~~��~����Q~��Q~~��~����Q~��Q~~��~��/g�>�g��ӈ�|���+w�|Ey��w��u/�w>��uJ��w:��wz�+w��Eyz���z�Ey:���:�Ey>���>�g�:��J�ӈ��g�z����k���k���������������k���k�������������<�k�<�k�-��-����k���k�����<�k�<�k�-��-��<�<�-��-�Ey������>�Ey>���:�Ey:���z�Eyz�ӈ��+w���wz��uJ��w:��u/�w>��w�ӈ�|g��+w�|�/g�>�g�:�g�z��J��<�k�<�k�-��-��<�<�-��-�(��ր��րܑ(ܑ��o��o��������o��o������րܑ(ܑ(��ր����o��o��������o��o��������������~���~���������~���~���������~���~���������~���~���o��o��������o��o��������o��o��������o��o������g�:���>�g�>��J��/Ey����Ey>���:�Ey:���z�Eyz�ӈ��+w���wz��uJ��w:��w>�ӈ�|g���u/�w�+w�|g�z����������<��<����������<��<����������<��<����������<��<����������<��<����������<��<����������<��<����������<��<��<�<�-��-��m-��-��<��m<��<�<�-��-�����������m���m���������(��ր��րܑ(ܑ�o�Q~o�Q~����o�Q~o�Q~���(��ր��րܑ(ܑ�o�Q~o�Q~����o�Q~o�Q~������Q~��Q~~��~����Q~��Q~~��~��o�Q~o�Q~����o�Q~o�Q~����o�Q~o�Q~����o�Q~o�Q~������Q~��Q~~��~�Q~������<�Q~<�Q~������<�Q~<�Q~������<�Q~<�Q~������<�Q~<����Q~��Q~~��~�Q~������<�Q~<�Q~������<�Q~<�Q~������<�Q~<�Q~������<�Q~<�L|f�{�o�{fI��oȍfI�f�~<�g?��<�g:��~<��<��~<�g?��<���?�/�<��<�Q~�ϐ�ϐb�Q~b�g?���?��<�g?���?��<��~b�Q~b�Q~�N�b�ϐ�ϐb���:�g:��<���b�:tb�:t������b��^b��^����g:��~<��<�:t������b�:tb�gAv��Av����g�������b��cb��^��^b�gAv��Av����g��(�b�}ub�}u�3��3�b�gAv��Av����g��}u�3��3�b�}ub�gAv��Av����g��T���ր��րAvT�Avڕ[�$j[�$j�tڕ�trSAv(Av(��rS��>����v���vAv>�Av����ր��րAv��Avӥ�w�� {�� {/��wލ {ލ}���ڞލ|�ލڞz���z�]�h�}�h�}�|�s���T�|�������/��ӥ���ڞ��ᝮ�|4��|4�d�
���
�_~Co�C���A���A��@���@_~C�}�A�|+Z�wPD�n[��PD��+Z
�Cj�+Z��Ad�n[z�}uz��\
�:t
�}u��}u_~>�N���߅��|�}���}�:����ϐ��*��|���
���͉Ô���>���
��͉7�|�t�ϐ�*����}��|��~y}�Yy\��|�v�{\� {}u�y
��w
��\�ڞ�v
�\�:�:t�{Eym�$jm�$j-�Ey-�_������L�_L�J��ԋ�ԋL�8��SsL�Ss�_������L�_L�*tL�*t��v��{���L����� {ǁ {ǁ<��<�� {ǁ {ǁ<��<�� {ǁ {ǁ<��<�� {ǁ {ǁ<��<��͍ɀ͍ɀ|��|��͍q�͍q�|��|��͍ɀ͍ɀ|��|��͍�͍�|��|��͍ɀ͍ɀ|��|��͍q�͍q�|��|��͍ɀ͍ɀ|��|��͍ʇ͍ʇ|��|��͍:�͍:�|��|��͍b�͍b�|��|��D�ဎ�2z���z�T�D�ݔ�C���T�����吹�吅���(�������>Q��=�C���V����S��J�V�獯<�>(���z�C�썁~���������N~�O�<��~�gz���(������V�J�V�S�g���~��O�=���Q����r���r�����o���o���<��<�r�����<�r�������M�]�M�]������y��y��z���Æ8�;y8�ÆA�;yA��q��zq��~�������<��~����o���o���<��<���ו����g��ו!���r�qg����q���L��rm�m������M��M���ye��ye���2zꎡ�ꎪ����z��.����������Í�~���Í�w}�����x���PוP�w������~w}ݔPO���q�����P��̅���j��!k�e�ꎙ����傘�������y���y�������������y��yet��}��}�et��~���Í�w}����h�����P��P��������~w}ݔe���!k���j�̅�󀍐��ݔ.����P�x���w��וP�.����������Íet��}��}�et�e������ye��y!���r�qg��g�q����rm!�m���{��{���������׊ �׊ �������dz��6�=���[��v[�Az���~sh�sh����~���͍b�͍b�|��|��͍:�͍:�|��|��͍ʇ͍ʇ|��|�xz[��}=�����t�[�����+w�wIq�Mb�TY�whX~ydu}�Iq��xvs��wT�+w�Mb���xڞ�x|��aN��a��wa�X��X�~`t�-a7�wa߅-aÔ~`���X�X��hX|�TY��w��vx]�xv��du}��x}�vx���x {X�D��D��ԏX�ԏ(��0~��0~-�(-��ԏX�ԏX�D��D��~-��-�����~��8ܑƀܑƀL�8L�8ܑƀܑƀL�8L�(��U|��U|-�(-�8ܑƀܑƀL�8L�U|-�(-�(��U|����͍}�͍}�<���<��~͍/�͍/�<��~<�,�<�\�<�\�͍,�͍�~͍/�͍/�<��~<�ǁ]��]�� {ǁ {ǁ]��]�� {ǁ {      aabb    u���  ��Չ����	C�bPB��C   	   uv_scale 2   4��AL7|A              index_data    �                 	 
  
                                  ! "   " # # " $ # $ % # % & & % ' ( ) ! ( ! * * !   ) ( + ) + , , + - , - $ , $ " ' % . ' . / / . - / - +   # 0   0 1 1 0 2 1 2 3 0 # 4 0 4 5 5 4 6 7 8 9 7 9 : ; < = > ? @ A B C A C D D C E F G H F H I I H J K L M K M N K N O P Q R P R S T U V T V W W V X Y Z [ Y [ \ ] ^ _ ] _ ` ` _ a b c d b d e f g h f h i i h j k j h k h l m n o m o p p o q r s t r t u r u v w x y w y z w z { | } ~ | ~  |  � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � �  �  	

  !"#$"$%&'(&()*+,*,-./0.01234245678689:;<:<=>?@>@ABCDBDEFGHFHIJKLJLMNOPNPQRSTRTUUTVWSRXYRXRUZ[\Z\]]\^_`a_abcdecefcfghijhjklmnlnopqrprstuvtvwxyzxz{x{||{}|}~~}�������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������� �  		

	
 !"#!#$$#%&'(&())(*+'&+&,+,--,./.,/,0/01234245546567578932:;<:<=>?@>@AA@BABCD>ADAEFGHFHIJKLJLMMLNOPNONQQNLROQRQSTUVTVWTWXXWYZ[TZT\\TX\X]^_`^`abcdbdeedfefgfdhfhiihjkjhlmnlnoonpopqpnrprssrtutrvwxvxyyxz{|z{z}}zx~{}~}�������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������� �  �����	




 !" "#$%&$&'()*(*+,-.,./01202345646789:8:;<=><>?@AB@BCDEFDFGHIJHJKLMNLNOPQRPRSTUVTVWXYZXZ[\]^\^_`ab`bcdefdfghijhjklmnlnopqrprstuvtvwxyzxz{|}~|~������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������  	

 !" "#$%&$&'()*(*+,-.,./01202345646789:8:;<=><>?@AB@BCCBDCDECEFFEGFGHHGIHIJHJKKJLKLMMLNA@OAOPPOQPQRRQSPRNPNTTNUTUVVUIVIGBTVBVDSQWSWMMWKLUNXYZXZ[\]^\^_`ab`bcdefdfghijhjklmnlnopqrprstuvtvwxyzxz{{z|{|}}|~}~}�����������������������������������~�~|��y�y��yx���������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������  	


			
	 !" "#$%&$&'()*(*+,-.,./01202345646789:8:;<=><>?@AB@BCDEFDFGHIJHJKLMNLNOPQRPRSTUVTVWXYZXZ[\]^\^_`ab`bcdefdfghijhjklmnlnopqrprstuvtvwxyzxz{|}~|~�������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������� � 	

  !! "#$#!%" % &''(()*+,*,--,./.,01202332434535665767868998010:1:;;:<;<==<>=>?=?4=42><@>@AA@BABCCB:C:DD:EDEFFEGHIJHJKKJLKLMMLNNLONOPPOQQODQDRRDFGESGSTTSUUSVUVWWVXXVYXYZZY[\SE\E]\]^^]_^_``_8a>AaAbbAcbcddcDdDOeE8e8_E:0E08fghfhijkljlmnopnpqqprqrstuvtvwxyzxz{x{||{}~�~���������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������� � 		
	

 !" "#$%&$&'()*(*+,-.,./01202345646776878998:;:8<=><>?@AB@BCDEFDFGHIJHJKLMNLNOPQRPRSTUVTVWXYZXZ[\]^\^_`ab`bcdefdfggfhghiihjijklmnlnopqrprstuvtvwtwxyz{y{|}~}����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������      index_count    �        name       Mesh z          
         ConvexPolygonShape3D       #      ���@���ڿ�ĊB&��?��B��H@`��A�P�B���AkZ6B��AN�gB&��?���D��&��?��B'�?B�/�Aj�UB@��c�Bj�&��?����W�@��c�Bj�UB@���C�D��&��?B����ĊB&��?B����ݘA�=B'1�A��m��(�A�< C��m�`��A�P�BN�gB&��?j��Bj�&��?j��B��B@�)\�B�W�@���C����@�)\�B��B@���ڿ�U0���B*��B��m��\�A�< C
         StyleBoxFlat 
   �          �         �         �         �         �         �         �         �         
         StyleBoxFlat 
   �          �         �         �         �         �         �         �         �         
         LabelSettings    �            
         PackedScene    �      	         names "   j      Drone    script    chat    pitch_curve    roll_curve 
   yaw_curve    camera_limit    CharacterBody3D 	   Username    unique_name_in_owner 
   transform    pixel_size 
   billboard    no_depth_test    fixed_size    text    font 
   font_size    outline_size    Label3D    Cameras    Node3D    FP    far 	   Camera3D    TD    Mesh    DingusDrone    material_override    mesh 	   skeleton    MeshInstance3D 
   Collision    shape 	   disabled    CollisionShape3D    Props    ForwardRight    ForwardLeft 
   BackRight 	   BackLeft    PerfDisplay    anchors_preset    anchor_right    anchor_bottom    metadata/_edit_use_anchors_    Label    ui    layout_mode    grow_horizontal    grow_vertical    Control    StickPanel    anchor_left    anchor_top    theme_override_styles/panel    Panel    Left Stick    Right Stick    MarginContainer    TelemetryVbox    clip_contents    custom_minimum_size    VBoxContainer    CamRotation    label_settings    horizontal_alignment    DroneSpeed    FPS    Chat 	   Settings    mouse_filter 
   CurveHbox $   theme_override_constants/separation 
   alignment    HBoxContainer    PitchCurve 
   RollCurve 	   YawCurve    offset_right    offset_bottom    Speed    placeholder_text 	   LineEdit    Label2    Thrust    Label3    RotationSpeed    Label4    RotationDrag    Label6 	   CamAngle 	   Defaults    Button    Save    Load    _on_speed_text_changed    text_changed    _on_thrust_text_changed     _on_rotation_speed_text_changed    _on_rotation_drag_text_changed    _on_cam_angle_text_changed    _on_defaults_pressed    pressed    _on_save_pressed    _on_load_pressed    	   variants    H                                                         -              �?              �?              �?    w:?Zd�>   ��D;            CSLR             0              �?              �?              �?    ���=        P�H     �?            a|?��1>    ��1�a|?�Q�>��>�p�?   
�#<            
�#<            
�#<                                                        �?              �?              �?33?    ��̼     �?              �?              �?33�    ��L�     �?              �?              �?33?    ff�?     �?              �?              �?33�    ff�?   ����   �8�>   �E�=                 �?         ���>   �Z?   ��*?                   �U�=     @>              P?   PUe?   ��j>   .:>   PUE?   `tQ?
     PC  xB      0°                KM/h       ??? FPS             E�c<   7�?   aU�>   vG?     �   �?     �                   �9    ��   
   Max Speed       Thrust Multiplier       Max Rotation Speed       Rotation Drag Multiplier       Camera Angle Limit    	   Defaults       Save Settings
       Load Settings       node_count    -         nodes     �  ��������       ����            @                                             ����
   	      
               	                  
                                       ����                     ����   
                             ����   
                              ����                     ����   
                                    #       ����   	      
      !      "                     $   ����                  %   ����   
                    &   ����   
                    '   ����   
                    (   ����   
                  .   )   ����   	      *      +      ,      -                  3   /   ����   0      *      +      ,      1       2                  8   4   ����   	      0   	   *      5   !   6   "   +   #   ,      1       2   $   7   %   -                 8   9   ����	   	      0   	   *      5   &   6   !   +   '   ,   #   7   (   -                 8   :   ����	   	      0   	   *      5   )   6   !   +   *   ,   #   7   (   -                 ;   ;   ����   0   	   *      5   +   6   ,   +   -   ,   .   -                 ?   <   ����   	      =      >   /   0                  .   @   ����   	      0          0   A   1   B   	   -                 .   C   ����   	      0          2   A   1   B   	   -                 .   D   ����   	      0          3   A   1   B   	   -                 ���E   4      0   	   5   5   6   6   +   7   ,                 3   F   ����   0   	   5   8   +      ,      1       2       G       -                 K   H   ����   0       5   9   6   :   +   ;   ,   8   I   <   J   	   -                 ���L   =      	      0                  ���M   =      	      0                  ���N   =      	      0                  8   8   ����   0   	   *      +      ,      O   >   P   ?   1       2                  ?   ?   ����   0   	   *      +      ,      1       2                  .   .   ����   0          @   B   	              S   Q   ����   	      0       R   @   J   	              .   T   ����   0          A   B   	              S   U   ����   	      0       R   A   J   	              .   V   ����   0          B   B   	              S   W   ����   	      0       R   B   J   	              .   X   ����   0          C   B   	              S   Y   ����   	      0       R   C   J   	              .   Z   ����   0          D   B   	              S   [   ����   	      0       R   D   J   	              ]   \   ����   0          E              K   K   ����   0       J   	       *       ]   ^   ����   0          F       *       ]   _   ����   0          G             conn_count             conns     8           a   `              "       a   b              $       a   c              &       a   d              (       a   e              )       g   f              +       g   h              ,       g   i                    node_paths              editable_instances              version       
      RSRC               extends Node3D

@export var active_peers = {}

@export var active_race = false
@export var checkpoint_manage : checkpoint_manager

var time = 0
var f = 0

var race_data = []

func _physics_process(delta):
	self.visible = active_race
	
	if Input.is_action_just_pressed("start_race"): 
		var peers = get_parent().request_peers(self)
		peers.append(1)
		for peer in peers:
			active_peers[peer] = get_node("../Players/" + str(peer)).username
			
			race_data.append(get_node("../Players/" + str(peer)).username)
			
		
		active_race = true
	
	if active_race:
		$UI/Checkpoint.text = str("Checkpoints: %s / %s" % [checkpoint_manage.current_checkpoint + 1, checkpoint_manage.checkpoints_needed])
		time += delta
		f += 1
		if f == 5:  
			time = snapped(time, 0.1)
			%Time.text = str("Time: ", time, "s")
			f = 0 
	
	update_list(race_data)

func update_list(information):
	
	%List.clear()
	for item in information:
		%List.add_item(str(information.find(item)+1, ". ", item))
    RSRC                    PackedScene            ��������                                            %      resource_local_to_scene    resource_name    line_spacing    font 
   font_size    font_color    outline_size    outline_color    shadow_size    shadow_color    shadow_offset    script    content_margin_left    content_margin_top    content_margin_right    content_margin_bottom 	   bg_color    draw_center    skew    border_width_left    border_width_top    border_width_right    border_width_bottom    border_color    border_blend    corner_radius_top_left    corner_radius_top_right    corner_radius_bottom_right    corner_radius_bottom_left    corner_detail    expand_margin_left    expand_margin_top    expand_margin_right    expand_margin_bottom    anti_aliasing    anti_aliasing_size 	   _bundled       Script #   res://Game/Objects/race_manager.gd ��������	   FontFile    res://Kenney Future.ttf ���:Ya      local://LabelSettings_aosfp `         local://LabelSettings_jb00t �         local://StyleBoxFlat_f24yt �         local://PackedScene_al4os 	         LabelSettings                      0            LabelSettings                                   StyleBoxFlat          ��?��?��?             PackedScene    $      	         names "   '      RaceManager    visible    script    Node3D 
   MapHolder    UI    layout_mode    anchors_preset    anchor_right    anchor_bottom    grow_horizontal    grow_vertical    mouse_filter    Control    Checkpoint    anchor_left    anchor_top    text    label_settings    horizontal_alignment    metadata/_edit_use_anchors_    Label    Players    Time    unique_name_in_owner    List !   theme_override_colors/font_color )   theme_override_colors/font_hovered_color *   theme_override_colors/font_selected_color    theme_override_fonts/font $   theme_override_font_sizes/font_size    theme_override_styles/panel    theme_override_styles/focus    theme_override_styles/hovered    theme_override_styles/selected %   theme_override_styles/selected_focus    theme_override_styles/cursor '   theme_override_styles/cursor_unfocused 	   ItemList    	   variants                                         �?               ����     �>   �EJ=     @?   �>      Checkpoints:                    vG?   ��=   #�=>      Players             ��=   	   TIME: %s    �8N?   ��0?            �?  �?  �?  �?                               node_count             nodes     �   ��������       ����                                  ����                      ����                     	      
                                   ����                        	      
   	      
                                                     ����                                 	      
                                                     ����                                    
   	      
                                               &      ����                                       	      
                                                 !      "      #      $      %                      conn_count              conns               node_paths              editable_instances              version             RSRC RSRC                    PackedScene            ��������                                            �      resource_local_to_scene    resource_name    sky_top_color    sky_horizon_color 
   sky_curve    sky_energy_multiplier 
   sky_cover    sky_cover_modulate    ground_bottom_color    ground_horizon_color    ground_curve    ground_energy_multiplier    sun_angle_max 
   sun_curve    use_debanding    script    sky_material    process_mode    radiance_size    background_mode    background_color    background_energy_multiplier    background_intensity    background_canvas_max_layer    background_camera_feed_id    sky    sky_custom_fov    sky_rotation    ambient_light_source    ambient_light_color    ambient_light_sky_contribution    ambient_light_energy    reflected_light_source    tonemap_mode    tonemap_exposure    tonemap_white    ssr_enabled    ssr_max_steps    ssr_fade_in    ssr_fade_out    ssr_depth_tolerance    ssao_enabled    ssao_radius    ssao_intensity    ssao_power    ssao_detail    ssao_horizon    ssao_sharpness    ssao_light_affect    ssao_ao_channel_affect    ssil_enabled    ssil_radius    ssil_intensity    ssil_sharpness    ssil_normal_rejection    sdfgi_enabled    sdfgi_use_occlusion    sdfgi_read_sky_light    sdfgi_bounce_feedback    sdfgi_cascades    sdfgi_min_cell_size    sdfgi_cascade0_distance    sdfgi_max_distance    sdfgi_y_scale    sdfgi_energy    sdfgi_normal_bias    sdfgi_probe_bias    glow_enabled    glow_levels/1    glow_levels/2    glow_levels/3    glow_levels/4    glow_levels/5    glow_levels/6    glow_levels/7    glow_normalized    glow_intensity    glow_strength 	   glow_mix    glow_bloom    glow_blend_mode    glow_hdr_threshold    glow_hdr_scale    glow_hdr_luminance_cap    glow_map_strength 	   glow_map    fog_enabled    fog_light_color    fog_light_energy    fog_sun_scatter    fog_density    fog_aerial_perspective    fog_sky_affect    fog_height    fog_height_density    volumetric_fog_enabled    volumetric_fog_density    volumetric_fog_albedo    volumetric_fog_emission    volumetric_fog_emission_energy    volumetric_fog_gi_inject    volumetric_fog_anisotropy    volumetric_fog_length    volumetric_fog_detail_spread    volumetric_fog_ambient_inject    volumetric_fog_sky_affect -   volumetric_fog_temporal_reprojection_enabled ,   volumetric_fog_temporal_reprojection_amount    adjustment_enabled    adjustment_brightness    adjustment_contrast    adjustment_saturation    adjustment_color_correction    render_priority 
   next_pass    transparency    blend_mode 
   cull_mode    depth_draw_mode    no_depth_test    shading_mode    diffuse_mode    specular_mode    disable_ambient_light    disable_fog    vertex_color_use_as_albedo    vertex_color_is_srgb    albedo_color    albedo_texture    albedo_texture_force_srgb    albedo_texture_msdf 	   metallic    metallic_specular    metallic_texture    metallic_texture_channel 
   roughness    roughness_texture    roughness_texture_channel    emission_enabled 	   emission    emission_energy_multiplier    emission_operator    emission_on_uv2    emission_texture    normal_enabled    normal_scale    normal_texture    rim_enabled    rim 	   rim_tint    rim_texture    clearcoat_enabled 
   clearcoat    clearcoat_roughness    clearcoat_texture    anisotropy_enabled    anisotropy    anisotropy_flowmap    ao_enabled    ao_light_affect    ao_texture 
   ao_on_uv2    ao_texture_channel    heightmap_enabled    heightmap_scale    heightmap_deep_parallax    heightmap_flip_tangent    heightmap_flip_binormal    heightmap_texture    heightmap_flip_texture    subsurf_scatter_enabled    subsurf_scatter_strength    subsurf_scatter_skin_mode    subsurf_scatter_texture &   subsurf_scatter_transmittance_enabled $   subsurf_scatter_transmittance_color &   subsurf_scatter_transmittance_texture $   subsurf_scatter_transmittance_depth $   subsurf_scatter_transmittance_boost    backlight_enabled 
   backlight    backlight_texture    refraction_enabled    refraction_scale    refraction_texture    refraction_texture_channel    detail_enabled    detail_mask    detail_blend_mode    detail_uv_layer    detail_albedo    detail_normal 
   uv1_scale    uv1_offset    uv1_triplanar    uv1_triplanar_sharpness    uv1_world_triplanar 
   uv2_scale    uv2_offset    uv2_triplanar    uv2_triplanar_sharpness    uv2_world_triplanar    texture_filter    texture_repeat    disable_receive_shadows    shadow_to_opacity    billboard_mode    billboard_keep_scale    grow    grow_amount    fixed_size    use_point_size    point_size    use_particle_trails    proximity_fade_enabled    proximity_fade_distance    msdf_pixel_range    msdf_outline_size    distance_fade_mode    distance_fade_min_distance    distance_fade_max_distance    lightmap_size_hint 	   material    custom_aabb    flip_faces    add_uv2    uv2_padding    size    subdivide_width    subdivide_height    subdivide_depth    custom_solver_bias    margin    line_spacing    font 
   font_size    font_color    outline_size    outline_color    shadow_size    shadow_color    shadow_offset 	   _bundled       Script    res://ACTIVE/Multiplayer.gd ��������	   FontFile    res://Kenney Future.ttf ���:Ya	   $   local://ProceduralSkyMaterial_bqarr j         local://Sky_u8v6k �         local://Environment_lgi4k �      !   local://StandardMaterial3D_iq1gi (         local://BoxMesh_hlg53 c         local://BoxShape3D_ljwan �         local://LabelSettings_i4gug �         local://LabelSettings_ngtph          local://PackedScene_qyvdq B         ProceduralSkyMaterial          �p%?;�'?F�+?  �?	      �p%?;�'?F�+?  �?         Sky                          Environment                         !                  StandardMaterial3D          |F">|F">|F">  �?         BoxMesh    �            �        �B  �?  HB         BoxShape3D    �        �B  �?�uHB         LabelSettings    �            �      0            LabelSettings    �            �                   PackedScene    �      	         names "   -      World    script    StaticBody3D    WorldEnvironment    environment    Players 
   transform    Node3D    DirectionalLight3D    shadow_enabled    MeshInstance3D    mesh    CollisionShape3D    shape 
   NetworkUI    unique_name_in_owner    anchors_preset    anchor_right    anchor_bottom    grow_horizontal    grow_vertical    Panel    Label    layout_mode    anchor_left    anchor_top    text    label_settings    horizontal_alignment    metadata/_edit_use_anchors_    Label2    offset_bottom    VBoxContainer 	   ServerIP    placeholder_text 
   alignment 	   LineEdit    ServerPort 	   Username    Connect    Button    Host    _on_connect_pressed    pressed    _on_host_pressed    	   variants    #                           �?              �?              �?      A       г]��ݾ  �>       ?г]?   �  @?�ݾ                        @              �?               @                                         �?               ����   ���>   �E�=   ��*?   )x:>      ACTIVE
             8h/>   �^�>    ��      -DRONE RACING-             *��>   v�>   �8?   ��0?   #   disease-technological.gl.at.ply.gg       IP       4382       Port    	   Username       CONNECT       HOST       node_count             nodes     �   ��������       ����                            ����                           ����                           ����         	                  
   
   ����                                 ����                                 ����                  	      	      
      
                    ����                                          
      
                                            ����                                                
      
                                              ����	                                          
      
             	       $   !   ����            
         "      #          	       $   %   ����            
         "      #          	       $   &   ����            
   "       #          	       (   '   ����      
      !       	       (   )   ����      
      "             conn_count             conns               +   *                     +   ,                    node_paths              editable_instances              version             RSRC     GST2   @   @      ����               @ @          RIFF   WEBPVP8L�  /?�� L�/����?A ������@:�ٶ�ƍd�eY�`Y���l� ���ǈ�;p�6�d��3��'���S����<�F�O�ñ ;�W�TSI�����E<`�1 ����ЙG0���@=I���h;�)�_CZ�%��!�")/ s��@%�4]i���X!���/u�jy��,Y��ų�5U�����j��k�Υ��'����Q� �g��D+�D���d��j�?gnM�CE�kYQ��'��@��pǱ��I�kMË��/4���@�$b̏�^����z O�_DG�$���U�u[�;��������5�T?*�����'tD4������[np0s@�D�5\d21.4R�wTnK*�����H�BQ�{S���s��u&��B�4}iǚ�lP�k�`pG-�Ǻ|9h���n@/�"����)^ F�By �"I��Ά��IbL��Źj"Z�R8h��!r�����_� [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://duco4oyo7wmk2"
path="res://.godot/imported/Circle.png-5aa705d158b14b9f860407e6f23b289d.ctex"
metadata={
"vram_texture": false
}
              extends Control

@export var curve : Curve

var max_value = 1
var updates = 0 

func update(c):
	updates += 1
	curve = c
	size.x = 128
	max_value = 1
	%Line.clear_points()
	for x in size.x:
		var curve_value = curve.sample(x / size.x)
		if curve_value > max_value: max_value = curve_value
		curve.max_value = max_value * 4
		%Line.add_point(Vector2(x * 0.85, 100 - float(curve_value / max_value) * 50 ))

func _on_left_tan_value_changed(value):
	curve.set_point_left_tangent(1, value)

func _on_right_tan_value_changed(value):
	curve.set_point_right_tangent(0, value)

func _on_v_slider_value_changed(value): # max rate
	curve.set_point_value(1, value / 512)
	
           extends Node

const version_check_url = "https://github.com/CSLRDoesntGameDev/ACTIVE-DroneRacing-Update-Repo/raw/main/version_info.json"
const version_download_url = "https://github.com/CSLRDoesntGameDev/ACTIVE-DroneRacing-Update-Repo/raw/main/Version%20Files/"

var current_version = "0.5"

func _ready():
	check_for_directory("user://update_downloads")
	await version_check()
	

func version_check():
	var htr = HTTPRequest.new()
	add_child(htr)
	htr.request(version_check_url)
	var data = await(htr.request_completed)
	htr.queue_free()
	var json = JSON.parse_string(data[3].get_string_from_utf8())
	var version_update = str(json.get("current_version"))
	print(version_update)
	if not version_update == current_version:
		print("version mismatch, looking for download path")
		
		var download_url = version_download_url + version_update + "/ACTIVE.pck"
		var OS_path = OS.get_executable_path()
		var file_path = OS_path.trim_suffix(OS_path.get_slice("/", OS_path.count("/"))) + "ACTIVE.pck"
		if FileAccess.file_exists(file_path): DirAccess.remove_absolute(file_path)
		for c in get_parent().get_children():
			if not c == self: c.queue_free()
		var download = preload("res://UpdatePanel.tscn").instantiate()
		add_child(download)
		await(download.get_node("Panel/Download").pressed)
		
		await download_to_file(download_url, file_path)

func download_to_file(url, file):
	print("downloading ", url, " to ", file)
	var download = HTTPRequest.new()
	add_child(download)
	download.download_chunk_size = 4096 * 4
	
	download.set_download_file(file)
	await(get_tree().create_timer(0.1).timeout)
	download.request(url)
	var data = await(download.request_completed)
	print("Downloaded")
	get_tree().quit()

func check_for_directory(directory):
	if not DirAccess.dir_exists_absolute(directory): DirAccess.make_dir_absolute(directory)
           RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script           local://PackedScene_hpx86 �          PackedScene          	         names "         Node3D    	   variants              node_count             nodes        ��������        ����              conn_count              conns               node_paths              editable_instances              version             RSRC      GST2   �   �      ����               � �        �  RIFF�  WEBPVP8L�  /������!"2�H�m�m۬�}�p,��5xi�d�M���)3��$�V������3���$G�$2#�Z��v{Z�lێ=W�~� �����d�vF���h���ڋ��F����1��ڶ�i�엵���bVff3/���Vff���Ҿ%���qd���m�J�}����t�"<�,���`B �m���]ILb�����Cp�F�D�=���c*��XA6���$
2#�E.@$���A.T�p )��#L��;Ev9	Б )��D)�f(qA�r�3A�,#ѐA6��npy:<ƨ�Ӱ����dK���|��m�v�N�>��n�e�(�	>����ٍ!x��y�:��9��4�C���#�Ka���9�i]9m��h�{Bb�k@�t��:s����¼@>&�r� ��w�GA����ը>�l�;��:�
�wT���]�i]zݥ~@o��>l�|�2�Ż}�:�S�;5�-�¸ߥW�vi�OA�x��Wwk�f��{�+�h�i�
4�˰^91��z�8�(��yޔ7֛�;0����^en2�2i�s�)3�E�f��Lt�YZ���f-�[u2}��^q����P��r��v��
�Dd��ݷ@��&���F2�%�XZ!�5�.s�:�!�Њ�Ǝ��(��e!m��E$IQ�=VX'�E1oܪì�v��47�Fы�K챂D�Z�#[1-�7�Js��!�W.3׹p���R�R�Ctb������y��lT ��Z�4�729f�Ј)w��T0Ĕ�ix�\�b�9�<%�#Ɩs�Z�O�mjX �qZ0W����E�Y�ڨD!�$G�v����BJ�f|pq8��5�g�o��9�l�?���Q˝+U�	>�7�K��z�t����n�H�+��FbQ9���3g-UCv���-�n�*���E��A�҂
�Dʶ� ��WA�d�j��+�5�Ȓ���"���n�U��^�����$G��WX+\^�"�h.���M�3�e.
����MX�K,�Jfѕ*N�^�o2��:ՙ�#o�e.
��p�"<W22ENd�4B�V4x0=حZ�y����\^�J��dg��_4�oW�d�ĭ:Q��7c�ڡ��
A>��E�q�e-��2�=Ϲkh���*���jh�?4�QK��y@'�����zu;<-��|�����Y٠m|�+ۡII+^���L5j+�QK]����I �y��[�����(}�*>+���$��A3�EPg�K{��_;�v�K@���U��� gO��g��F� ���gW� �#J$��U~��-��u���������N�@���2@1��Vs���Ŷ`����Dd$R�":$ x��@�t���+D�}� \F�|��h��>�B�����B#�*6��  ��:���< ���=�P!���G@0��a��N�D�'hX�׀ "5#�l"j߸��n������w@ K�@A3�c s`\���J2�@#�_ 8�����I1�&��EN � 3T�����MEp9N�@�B���?ϓb�C��� � ��+�����N-s�M�  ��k���yA 7 �%@��&��c��� �4�{� � �����"(�ԗ�� �t�!"��TJN�2�O~� fB�R3?�������`��@�f!zD��%|��Z��ʈX��Ǐ�^�b��#5� }ى`�u�S6�F�"'U�JB/!5�>ԫ�������/��;	��O�!z����@�/�'�F�D"#��h�a �׆\-������ Xf  @ �q�`��鎊��M��T�� ���0���}�x^�����.�s�l�>�.�O��J�d/F�ě|+^�3�BS����>2S����L�2ޣm�=�Έ���[��6>���TъÞ.<m�3^iжC���D5�抺�����wO"F�Qv�ږ�Po͕ʾ��"��B��כS�p�
��E1e�������*c�������v���%'ž��&=�Y�ް>1�/E������}�_��#��|������ФT7׉����u������>����0����緗?47�j�b^�7�ě�5�7�����|t�H�Ե�1#�~��>�̮�|/y�,ol�|o.��QJ rmϘO���:��n�ϯ�1�Z��ը�u9�A������Yg��a�\���x���l���(����L��a��q��%`�O6~1�9���d�O{�Vd��	��r\�՜Yd$�,�P'�~�|Z!�v{�N�`���T����3?DwD��X3l �����*����7l�h����	;�ߚ�;h���i�0�6	>��-�/�&}% %��8���=+��N�1�Ye��宠p�kb_����$P�i�5�]��:��Wb�����������ě|��[3l����`��# -���KQ�W�O��eǛ�"�7�Ƭ�љ�WZ�:|���є9�Y5�m7�����o������F^ߋ������������������Р��Ze�>�������������?H^����&=����~�?ڭ�>���Np�3��~���J�5jk�5!ˀ�"�aM��Z%�-,�QU⃳����m����:�#��������<�o�����ۇ���ˇ/�u�S9��������ٲG}��?~<�]��?>��u��9��_7=}�����~����jN���2�%>�K�C�T���"������Ģ~$�Cc�J�I�s�? wڻU���ə��KJ7����+U%��$x�6
�$0�T����E45������G���U7�3��Z��󴘶�L�������^	dW{q����d�lQ-��u.�:{�������Q��_'�X*�e�:�7��.1�#���(� �k����E�Q��=�	�:e[����u��	�*�PF%*"+B��QKc˪�:Y��ـĘ��ʴ�b�1�������\w����n���l镲��l��i#����!WĶ��L}rեm|�{�\�<mۇ�B�HQ���m�����x�a�j9.�cRD�@��fi9O�.e�@�+�4�<�������v4�[���#bD�j��W����֢4�[>.�c�1-�R�����N�v��[�O�>��v�e�66$����P
�HQ��9���r�	5FO� �<���1f����kH���e�;����ˆB�1C���j@��qdK|
����4ŧ�f�Q��+�     [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://cux7et251qxr6"
path="res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex"
metadata={
"vram_texture": false
}
                RSCC      �  �  H  *  �  �  7  �  W  D  (�/�` 5. j[�H��m���|E-W�2�܂�D���ӛ���1'�����b��֞���ƁAy�N��d��c�
%q��F��� 9��ԉEɵ���6��9^�$`��$j�k��F�\�5����H��3{Ks�
Ւ�i�jT�^5�|�T7ޓıcyw&ͩ�Hv�/�?�����K[(2uu�e��Fz�;�&�����T����xq(ٲf9�}2��(J�pf{B�~hj�&���yw���s�޵�=��{F��OӢ�j��y�f��?�Y�ԩ�n�-�^�>�7�-Y�.pd�y�N��WG���űcڎ'�K���V����������i.�h������e�����!��n�-����w��	���b�p�%L�v�*���|����� ({vU�&e,E
/��x�����B�����%�$Ռ�����Ŀ��6o�TecL��<CWG�b�gLeuG�r2?��e�9bo�DǮ��~+?�����r~�?'��)ɛ[}0�Oh�#NQ���Ȟ�I�*�õ��b�uޣ����gpL��|TJЭc�v�c�j�8���Bh��.pf������oْ5�95�|���mӦ�i;>�&�T�Kx�O"�]=���{���x���|;���<����|��W�|��/s�K�3	x(8��p���n���K��/��������y���� x�C������#�����y����<��cż�#���˫/�5{�٫���>g�]�G!{���?�7~�b��o�̶̞��v������|C|[�!*#~)~H~I~U~[�AcD���{	��i��b�(�?b���gKc���1�l�_	�����x�����8�JL<���*�1%~��T$�F�F|ш��QB|O��M>���U����6���p�,���lo��h�R�kex����"�/���{!��*�8�Dx��UO��_Foe���ӌ�H��jO�=փOz�\���{�V�_�=���n��|�+Q�6���w	�k虆i资I� x�k}�<A�z%��_��\����~�����-���y��gxޫ�����!C"#"""��0p�����`t-�S!Db����u��D�Ӟ�ȶ�����M0��	Y�',�n��?����y��Rb�`��3t��!�f0�s������Fr8~�ϑ<�Z���������v�ϵ��{�c,%��b0Q��O��SԦ�23�\�6�1�ķ�bc@����,X�[1���*�5�ul��Op�@���ɄP���MN!$0b�ErO�|D�J��S���8��a"I�&�(5F�����T�__BI�M/�K�;�xp�,��&X�/8��+LNO& EP,���z
w� =�ޛm<����r�}�l6��G�Me/�3�'��<�X���V�Rs\�/"Q�U&�;�˶�T�z���d�ů�T���܏"�+	Q��1rb(�/�` �! �`^A �(��`Ñ;�]��:��
pBT	��� ���+��B/������WqE��ܱJ��|�-SR K I -vz��G8=��7����m�^e�M?b��F>�ȿ��+��JO��&0|��B��w1z��0zD��!�D^�·�<���&�r��!�A��XE���=�X�;�ϼ�U���WR������YP>��ϓ�L^3�%_*y�ԯR���A�aPς����9�ru�U�	Z�	�W_U�?�&��b{�&���O��9;]�2�ӝx������7�;��/{���?GY�x��ُ�G�~��?�s�n�2N�s~2tv�s��8�7;g;ܹ��f����t�8�h�1�EϞ,���27��Vȅ^�j��>MI*���)�w ���()!C2"���$I��5M���.���ԥ���#$-�JS�iD/�F�:�u�YϠ�x���8E��j���{%����(�\��۰�t�&��2᯻�T	GU<d����0�d
�Ёfc;�'�� � �k̊��V�\/#s���/�ԾUy�5G"9!Yq�����<�ȳ�eW�[T�N����G=����C���w�Wo�
����
C�Πá���B���h9��]{��IZ��c«.�D�4���������Ry��B���m�o�)��W�S�3��`p����w�~� ��R@��Q�Y�o������%ߙ��χ4v���,������`=Ґj�N�e_��tR��� j�L�όk|�0��6���J8��@�9��dD��Q�ퟙ>�e57�@h���{�������� ��ۯ���]�$��	�o9Б&�wB�ӬJ���`,�)k����d������,S��4 C�yf��97�Hxc|��i�R�t4de�Ѝ>��Rcj�-w�4���`4D�~����ׂ*��j�ϋ�Q����,B�q��.�x��y p�Mu�r�!� 
N5z^�����U�(1oM/�R'�^5����J̾�y��5;%���ʮܢ�!^�M�<��_�t�bY�0��9�2*;L�m�m�w��T(�/�`  R#%�'Iψm<��g����uww��T�T���bG��/m�J݃�kd=�M^����xy�G��q��@K&�=D�:,�ЦMS�.i�!>��)t���S�n�\b#�������>�P�e�2e��	7���|I�?�S��2MR��4�)�> �(9��)H����k�ؖġ=��q:���N�ɂ4�@A�W�co�j1*���r~�8 {�<Tf"���ݗ��\�}�7�:�:ID'<�r�b!ܡ�沼���ʦ�)�>��:�{���"C�i��Å���}�~������k�r�f����0�U���};`���F��Kb�g}�6;�)��w2D'U���
��#�~���l0l |${����=;�!�y�w�W*z*A6,u~���6�Ax0�hl�V���L�f\C�!\/Z-�o�j��"5��Z�5��xդd$�r{(�t�%�È���W~� �Wf�y̷J~�k��ݧ�7�>>�#&9AX}���y,��8}��x��nQ�Wn�[����wIH����&K��c@���?Y4�e\n(��x1����~\�� 7�����VP&O��v4���r�)E3�MB�c������kxE�κ���h�ȹG�9��uC̢?y@�|Zy="�|��FR Y���]P#�l��Z\� 9ȬB5ޭt��(�gݏ�)��U���3������b���l~���F^vg
Q���_����琉
!�q�Ԋъ��mʯ)�ʲp���B'凱.���ͷM� )�.�#~�#����ې�qH�����L�ii	�R(�/�`  �-(�)I�\h��?G`$F�l�&�/M|�P�-�7�~QjQh[� " " UL���D��Gt�I%?�7<��B�>�{�ˬ�OD��C��Խ����)Z�DY���VZ�+�{�3���%�ۂZ)��Ԋ��X�Uӟ���87;�OH�ۛ��Y̐=D?@q��1i���3����1�t�^�����I
��q��<�|��(��0�BS3҂��Bac�Y9F�i"�'QT��9A�����9��F��ݕJ����S|.>H���Z V�	��B���-gm�q+�u�l���V=�P"�S�o��w�?PgD]���j�r���+٠;A�W���t�ٿH��f$J�ݗа,cj2he�Ɔ��񯮺׀����5-
�j�#~S]�+�L���Q愬s@�a���(~��d6ŕRi��S\[�4�	���_�P䶿��	��-gz�lŴQ������I%��;ΧL'1u�e���f�3����� ��\7b2�E����#Qf�ǡi��=3T�▅���`�E(*P�&�Z�8bR7:�^�迂 y.�n4;	n�.��$�g�9�d��:�����S/��m�]9]J@``�ۉ��B!Pv�iH6���mr,[P0q��p��9�.˛��~��j��ȃ�  �-��3N���BX�9������9���@�� 7c����8�X��Ǳ�Xa���������ol\�\T�\S�O��$���`�{�e\�h��Щ�Z�.��,Fր4�dP��<4U��
e;Ԓ*�)�h��XFX�hqM/�~V�7^_��k�:>&��e��4K�y=�!]�d ���!�9��Σ{ӄ�����2Ҋ����c�ܮM�k��ee< P�Ǆ��<����]ڹ,����|Jq�;_=H��0��jm@�A�#��,2r,/0JCd�,HK|.[�ޔD�O�j��2O��0�d�Q�E�>U� �jL겚�	E���(�/�` = 2%)�)I�\�i�7�23���FҘ�@  D]D��w��8�D�m�2{_�ƶ��]�f�>(xIL|���d�z� �������n�a�#;s��X��>}J)���J�:�~�\��c��;�Ջi�z�ϩS��|4�1m�t�'3s�>�(d��{/���2�$����(dz�� �%�!�BDD"�Pdfd7%J��!9Lb����4{�(�2_d�*�#-Q�p�+ї8:׭�e/�x�,���Ӈ��_ʁ�)
5��r_*4��P�#�J����xN��֞0/������� o�boqNy��*E��S���SA��e��W�qf	k��'���1��:]�e�x����9(9�/qf&[��xqEQ���!8���q#	��ʹk�6�g
�E��`���9#�,MH��uW*6�X�Ch�ֳ��$4���Z���� �cN��>�4Ũ�7��o��|�no�#c�N	���#����c�A:&F�Him����*'Aq�k7���J�����>����\7q��L�����=��rʴ���kH���B̯ٶa�5 �g�e��;y�z�N�Trs[a��zG���;�ݧo�E� �f�h��ٰ#��&�#��G����e�9Hy*�,{VCI�$�/�5��e�.g�(�"`��y��j��W���o���;,�b��KI/{�ɖ�S](�UN�>p]}�-�CнS(�/�` m ��''�)�Ѕ����333*33s��p*�o�[�?_Em{���q��"��n5�����
AӊsV�� fx����	3V��,�7c���>I�N�x�1�Y�X�(>N<���A�uy�����I�J���P�D!����Gx��V���>�sΏ�#�4�|�;���L�T:�� 樖|�� D�4�1���@D&	D��$m �;?�N!QP����������(̝�f�,�GH~�i&�k϶(�RN}�O�X���@
�,���z�oj�� �ql����nVp�<W�\�{�������b�����~߼M�O`%��}��� �:�W�˯��Ws��}�-�wgjCT�q$��dٝ7ŉv��dĹYoˋ51wV绛�>͂f�,��"�Ѭ���x�jK.}Ц���!н�/�
��G�䨏���S�;�@�cf���)���7��
�G�u�1�3��(�E&�ѿ*��)t�I�lQ���6�D��QE��O�H�1D��zc�H@5����+R�@��0��Ƅ(�?�b����x�%M���,�bo}�[�1�����x�$x�x�z:9{/ك����2���V�@���Q���+�^�P��L�\"֞E���|�0	л����J.!�k��TL+�/�;c�θ����}e
ysq��i��@����_���y�������ţk~�
�[\lYw�A�%8̒[|�N?�sy� ������tI�*up�b�&����@W�#��u�7�RDJ�<�(��K�jEG�� �U�v�#o?��ۋ�*V�(�/�` M ��&(�)I�r� ��Ȉ�XEQ�.7�?"���?�������6��a�����"?8���Xm^���h�G��ˊ���{��9n6�L|�豯��B�X�	3��rILə1F3*Ĳ�Ѩ�rG�FU��F ؚm{��w:��o���ӧ+�����>�}���&!I�R�1���4�|���9f�1�D	$�i��
��e �������H��y��no�� ػ���7tL�N;�^J�9/H�s���Z����u�if#ڼN�N]-kX��o��R`- )J��7C5��C��c����r�~
$rkM�%�l|�aѷ2�K�,(������h񚦱� �d�϶��U�W�_�XT�ym�2GlP#���C�a��%��3��	��gU(#�_��
V��"�3��5ٷR��?�#I����c���l=�Hi,T�l�sZ�g���h���3��o>�'D�
Dl9m$_�{�2]���p9�e�}Qz��/��h���?����'�I�yf������f=^ڒA6nQc����J�ޞU��/R��
�;L[�5|���＇Fl��̽oG,qA�Z}�9d=��K.]Z��j� zM���=�-��o���K��P��r���1a��]V6��K~�5#)�;>}f��h_~u�ƅ���&��န�r�.dNL2��[��D2L��3�%@�����}'�]�t��(AY(,G9#a� �v"Qy* sثB(�/�` m �'*�)I*��;�#rDȄL��t^���G��h5k�)�l��C|�.�����l _#؝/�7d&���pcUO+�蛣�9V1�w�� 2�);4������;��y/A��oѧO�8ܰ�WZ)�>a���%=�)	��Z��\��f������Q����$ɰ�� &)�n`�ţ0��1�3#""��M���<u�֏���_�in�
+I��&��vRy@[W�����zӍ�[�[���ēa9����J
�/�4kd��WN&�>�KH(D�qzƶ!�gg���co�G`���\pL�7�npWG�C3w;Gf����%@i(����J�R�P�k�d/S	j������f̽!��ms)��~�H��++P��wa`x�#��+���,�2TU��m�=�j��eᑸ�G'�֚�I
hs�|��d8R?�u���(B�z�R�[���1���^�F��p�bU`E&�,��ݸ%X�[�8�����yb��1�/��/��$D8�w4�����	������μJ1�������Z1�R� �����^i�L>�4E�~I��-B�S��t`?'m����*�"B���xp�ϧMz^�=�U���ᕓ�M�>�w�l�~n���B!6��m=�+ xlj��"y�G�䱏~�MB\�v�D'u��܃��}1=��wصV*),��#�эH�s�
A�:��MTE��<����Ks^
��n%�T��Dl�_�7棱y��f�^u����:'W#8P��f��`$+��1/s�{����Ž�n�oj|�Sc��Ȭq/C��Ԫ}�GC��$�����/v(�/�`	�! ���F�(�����k�~x$5�����n�5Ъ��on��+im�L�c�+K�a���$��˵�>]ĩ��+j��� � � �茘�I�WD��V�1��" ��|�a�c�d��rǅ3`�!��#4��9/4�5�����2�͹�f�Y��� B��,2��WTdVɐ�N�18J�;��x�&,�p��;�)��6���[�P�d��3�w�-G�G��1M�?b?b7b���,��2�v�?��07X�k�;ݶѨ�U���y6��Yk�RP�Xr���W�8G0�є��Qm2111���%=�QP~�)kM`�A�-(���fG����>5x�sm]}�i)�Z���m4�U�ǒ�gQrU�c�n��~[�pV�
J������Ѵ�[��Xr�99gXC�Q�����V/��WK�jt |F;oo�Lo]Y˻?;j��b��۹w��>��\I�ϡwp�7}7�����Ү��97�7>���,ʢC��y�wx�{����n-MC���5���E����ں�%�Η׊)6~��Ml�;�6�G�q��:m4R0v�jKM����M���r���3Z,X�#?�W�MJ��$gѨ�<=����v=�戂%/�N�[�S����7�Ho�����v۩O�}���ykX�Np#�E�,����z[&f�3o��m��q�蝦���L�5��]�v��?q��,E����,�'&D�$Is������R�r�3��$E�ҰI�@��F���l��WI10JeA''R��:��B�A��B����!=Eٹ�����!�_e��zf|�̘�}�w])�p��������h�?���=����@���^?�Z�)D�B���O��Jm�vE��m�r���+��?��%�W���r���Z�1�i��o�YKO'#O�(3s��*O�d<�k��4�2P�y��U�ǣ��PN+���G!���9:!`N�6X=�w��~��!u��V�)0�(j��IG�߬��H`�BJ�H �dfDP ɠ8��ޭ����Kt�Ө�X�noq
ˋfFx9B[�a_�,�ւk� RSCC     [remap]

importer="font_data_dynamic"
type="FontFile"
uid="uid://h3p0f6phkh17"
path="res://.godot/imported/Kenney Future Narrow.ttf-4d942de0caa573f3771419998628f0fe.fontdata"
 RSCC      �  �  M  X  �  �  9  �  W  M  (�/�` E. [�H��mր�|�?��<x������p���K7v�d������t�}�Y��W�<����IB+v����N��^J��� 	� �T������|^�D�rWwɳ�m�	x��x����6q,���F�8�h�}^/Y��U����ěB��Mѿ��Ds�5G�*�WW֘in\���eV/{�8�}ћ���
��0P����(W�sT���H�7��Α]KR$��T��y�s��J�|��N�d�ME��ʴ�ig���*�s*/��	Ů{�Ng���9��9�7��K˜x�Q��u�sّ\]��&�o?�77� �絭"ʊ�hCM���'t��/������Y&�'������_m��%��ځ߷�~�ہ�_���?�v�	~؂]��5�%�hK+�>��)�%<���e����Li]������.p��u��{m��)5��@�L��)t����Mm�<֌wrdB~?c+��1��yN�I�����U��pA��xq8
�#4�C�G%�-�����r�2��^���CRj�Hǜ���I�F��@FG�xryáD�lZ�����"���.l%������^�|
/Ɏ��.�2�neY�i�)ʊNgi�5>���<����<��F=�%{+�ɾɀ�V<���1����G;o�X�|(�w:��|��C����7s>��8_�y%�E���3 Ou�67��y���j������B�L45���gɼ��k��6�`^��`�	�����콼>��^���S��>�?����tQ`R`VU�x>xT�!�*�O�ʈ���UoI�J���+r��L�W���C� 
��'��@|t������Á~$�5�u���ni����I����N<���1������$#^fē"ށ��B<����\�~��=><�z�!���WG/;���km���C�_�T����.�҅Ob�,�Ԅ��T��"zD�#��o��B�_��A��@�"��[<�ڃo|��[4�)����,�؂/z+*x��"�c	�L詂�(���c}�J@_�󳟗
~��t�|���|���<���s�����f�������2DHDDDD$I�4��*"v�T-4�!1IAQy�R��mF�_�9�-zC-�@,�B5�Hd ��I��4���*������?���Ad�v���S�xM��f�����wϱ�>�Є��Oe�t�O��
���SX9>¶�8�TP��y�j��Ke���d@�^�rC
��ya��׫r���;d�a�h�md�E��s>���U�@W�֛֘3礄/���l���ȫ�wj�(ĵ���zS"t�Do�[t��Om<+h`+l�r�F==����l�C`�����><��Cب��z��炸���܇��g�m�,:��8����Q���(��� ]��M\������6��>2���vpb	�v�[��B!�Y��xz�	(�/�` " F \<Ѥ9Q�+���?F
��9�ڪR(F@�wC	@$�^�}����'�F.0ז�8t��)K I K �М��枙̼�a���3��QtX�Mlx��a� fT�I`���A���z���'*����;�p	��K�[�E�c9�c�&��H�lc9���s�wD�"�S�-�E8����s��an^q��)l>�,���^I= �P�<5���>�jk���ʦrA':��q�����[)�][�������B�6�kI7�������9k��(RS�;��#�SE����d�geH��@c-#awU�D������V�2e'�V���5�[CGt4nMrm�jU����m�8��q햩�8����R^Վ�[��i��:Ij���%)�v��	�0�B�dF�H����*��D�݅�ͮM h�*��g���d��SY%ʒ`Y��`8�
���拀"o�Uyf���������2a�]4�2�-Y��@L�۶������~C�c�_6�P���ڝ�ĿgUvE�m��M�#����\*�Mr��;��RCQBm��%�N:���������7����>�#�Z�i�)R�IT�H̹SQ��B�ؗ�c�R�v4�EM��ڳv��ja����)gm��>O��)��%������hpO��־�8���=����0���7v�6��� #���7�>/Vy�'v�ZS��y���&�C�疋�a x٤��Xi����q�VƗ����2/�㑠�}�࿜��|�_��Gf�㶁+NC�^rxgP�,��Dy3O�n�v؀kL����`:f��׃'�rv���,nٖ	 �y�!�ye�*�pe��4<*ܷ�X����`?&*�V�䧨����Z��?��=�aPܟ���@�	w*F/�$׵��Z�,R�HG��=�8�ʕ�&�@��iE`�b�RY�h��gj���	�u����^�5jgdw>�$��z���i��!w�/��p k��Np��A��=���
F�ݍ��e��x�@C���Ya��y�2��(/��򮾼�ϋ������%��L��Nh��`����a_ud����*(�/�` u "�"%�)I���st����tʄL�E��b�c&ⶶ��d�
�d�����XH�P�2���[fh˦JuZ.�0cE�M!�G�ic�ԡFy����d*˦YV �>Ol��*#���ŷ���3�f�.�P��?�P�L�/���_��.�$���1��`�$��$)�B##2$I�2�g�w�5u���R��h�<>���c�-5��gYَ�7A�n��x	��D�S�9�T��m����t����B��v�g2��7W��=a1�&U�:\�uZ�)�k&�(r���E���u)�`���d��gj�,R��\ՕĀ��G�nGĉ��ߙG���*y���	LC�l.��E��j;=�^\>0��:��{>]���;[|�km���!�k����r~�{��)j��_�:d�z}@�V\.��L��h|]�|�4G�G�*��lx�TS�T�����7 �,j���p:?Px*k	wF�y�D��^��3	��2�$�QlB�˅�s8퇦UyN�VA�1�:��O*��<�Ʋ�!%]Թ��Ձi>����p"���zs`=c��E���z:�T"w¡��
@~���/$=�����~�ʍإ?�.�s����®P,�������N��ٮ�;q�>��;Mb x�L,�+�@S�b?�F(�;�I���c+���4+Fq�`�V �.�P�AD��OǐN�������u�Sô��@�5N@ ���q+_�[?&$��7�:����i� 8���i��v/��Vh��i���|y���QNwK�����lX�ـ�Z���$�������3��?�~*�e�}�q�D �P��,iJ�6	�[�(�/�` � ��))pi�V���8�q9����UUUu �_Q��^�UԀ� E�L�^���(�ӎO�K�a�Nz�:Mv�({!nxrc�'�ۃͶvB�3=V�Df6x�fN��#ڲhh�&��V�~d���,3������T/�L��-�T��Oz�a�){�7f��_�h���������*�$��a���z@� G�<�2D"#I�R=:�L ,̘�	O"c~�F�'�>�[//X����:��/��W�����̹<��D!���w��nGQO<Hi��
�����<Ĳs��lw��u�	߉�QGxm�!�<�w�t�'�fթ'�ń��l����2��_D9���$��!����a�$��/�mS��ĝF$��Ɵ_@��,�x�v�ロ�%Nļ��t3ZP��t�3���S'OP�:X�jV�w���d�8��H2�B}��������=0%�Ub*�7^���^���-(	�0El�Bڲ�#
��h7PTd�`vT3_9� (�,J˄��^�*�B�Q|[�f�<t_�]���<��ѽL�ݭ�=B�=�k�f	��(0�#��e��Gˮ�!Γ�(����L�y�&n�u.ូ�V&X��C�!�����<�����J��ʥP����f�fÙ9�꒨�o������K3R'�"0{���[�(��������� ��i�üOz(���<dt'-�)����hv� (���?�>�OmM:�v$T��e�|���i?�F_Rv� `4��ݣ/9�{�0-c��tb������z]Og"(���1��s� w��B�7����!B�U�S�
,b�1}ooBn
���r�Ap�aqC�|��'�w"�Xy��=�L)d��k� ". ��[a���	�%�,$F*���/f�r��(�N^��>8�c��-E�H�b�/jdT����wU����.��=T�Su>F2���EӛG�"V#�tM�
(�/�` 5 �(*�)I�\h��������!iLP �jk��W���uh�iD�L�����	�v���O.	����� 3���.�?b��1� ����v��%;�!<��b]��K+���}jih��g��}�Y׍�����K-���̲�҉�yE�>����Δ�����c���*��$�t��(�t|@�(D� c"""��"���H��'� ,_�9V�&�`�`�mX��z�,�ËA�x� )`����}�@����V-]����E����*=6�Q?�����j�{�j�Vkޞ��e��|��.EѫӔ���*�v�J��Z2w�fP�	O���)�╃���x~;;�I9V��s�?�J�6��?�e��)��Q/v{P	���g'喽����W������K��3����5CV���SٌQ�h�`~=*�|����e!�!Cum	���O{�1�כ����>��d?;�H�x�t]d��u���>� 1��Fʴ̤I��j��/f6¹�s-�Yq� ��6v]�q�Mqӥ����T+?��$�OB�v�s�؂�P�F�8׀�(TUD���X&�TBR3_��\�~6��W�{�}�wi�]][��Cv���f��	��Z���(�C�o��êԪ�#/nCg�.\4��e"J�Ћl,� y3��,k��\����t�A�N�%@�,z�Y�ɡ{_��i@�JD�Y��G|�A��HT�QZ$�b� �K�j98c��(�/�` } �((�)I*08@��F&dBg4A=�u���@����3�{��d�L�ū�:3�'+�*�L�4>?�q�B�)��WL;lp�آ���h��
��2c�S����s�"O[��wmP�F]^ff��i�G'vf�xu���ꙗy�+�h�����p�3F���s�3���H�$�qF!䴅w����$*��!2���2����"blųV��˽
gmY�ϴ%���:�i�PLą�U(n���~Cwô<K���tܕ�}6�C�h]�L���6����82�6�������}D ���.z�hx6b�y�'�A���ߠp���S��as~:�� ^7��8m�2�9���k�!�1��8âZ���T�0:ř]���@�Fp�Cp�3zX�"U�%�����T!؞F����)E�l�bh:c��/�4Kj���L\��GJ���:8J�ft��%��5�9mGǯ�Pr�ӔǸef�[�V^;w�i�:y� C&@{|��70gw�C+d��r*�f���P�H�CK�[U�<4B�l6�g�F��gC���fg���f�������e����b�ww׍�U���V_�c�����@R��lf��w���^O�[c�kX2i���g��鈞̹����>w�+�ޒ�b����.|��µ���=���R>DZ����H�#C����4��!�'��;X<�I��ia���U�����?���X�[R���!�R�*�t5�hѐx���"J�����yn��N)���Ƀ��pN��>�:ۑ�D���Cx
�b��9G�a�=�?(�/�` � r�%&�'i��``sTU���� ���oG2"Ȫ����_J�N�
�af$�+FF�,����lQ�F���	�3>0�`n�[�Ԣ�B�h����f����ϡY�P�>(��U]4gTU5�N�N ,�Mk��m����p���+�O�6����=����Ѧ�$���!�t|���� �!f	DD$�DFDF�'� ֐��έ��F#���܎��ަ�  ���Ƈ�U�)/��&Y^��8xѡ��f;�~V�y<K�ڝMCX�N3!�m~nPz���fu�s�($�k*
^?��[�׮ٓ�Xj��,�)qPn'��cOᏫ>�y]��E�~®HIa��M�n��@1�N�������6�i���"\��7��-�Gu�'曭���]��m�n��u�g4J�m�l�󔮣
<$h�4���p���<6ؤy�<Ye6�j��eIj���}����#?�����
v!��Œ�  ���b3�mFۯlT@�b����o�ƨ�u,~��\�b�45��]�e �Х��2T_!�ߗo?�"Qv�cnh���� �A�PO��+-�t��$���f>���kQFDa�
���x��4d����S�S<�Yz[H���dL�@+Ŷ[f���V4�.ۍ`�&����͘5l�p�=a�p���1�$iXhe �v�h�4`P] �UU)ZH��W���e/�Bc���'�%��%FDRǷn��]��o(�/�` m Ҏ()�)I*��;�/x23��(��F&����G4��7����e
1�t�*����ǎ�����z�8�F�ӧ�����c11�	<57�����#3u�>(`�N����^���M�O$���d�f��?}JQ&�:u��5;<�Y��83sd�̐3J�E/�RJ��L���I�
�e��稄=�� � �RdDFDD$	�����]YmQ��Z� i?l�̅��V9�J���Z.���DzN��ff1�����rR �"nf(v"Qʢ~!���j���פ�ݱZ���r(��sL��k�y� �h��>��2C��E��Z��{���7�������y�B��俠�!h�:�h���:c�G�!�C�7CvƮ�r���tШL�f�Y~N�6�Q{� �@���Z�%SP�B�}��>����˺㼳8�"vB�H:,�-��h�m�v�y�����tb���ߕ�	6P��	r�J�e��"�k��~�ic�5�eɧ��N� ;�$"d���;Rr�
�e�Tp�j���	<wy��$��\�<��'mLbVکj�dԒکJ@����]d%-q����fB�5/�Y� @�� �I�8l(�s��}�����԰�g�M7��c~�9\��{�~�N��gc�ˍ�`�[�j�cJ��!��j����4VE�t|�P�0Qߝ�T�H[Bwuq���Z�Fv���#�xf����
�ؠ��c��"f���&�DE�D�{D���K2���gO�,�:^�5�yN��h�+��+���e��S �Vٕ��Z�p�|Z��A�*Ɩ�v#�v�:/�`��(�/�`�" f��E ��5S
j*	�h��R @�])� %R��q�vm����փ͙,c�݀3�(���m*R�D������ � � ��H�DF�󈋌e�ـ?\aO���L�r֒��� �%��9�c4����D����A1�Q�L�I�=lc�KT<`����Zd�'(�����;.���{�o���6J��lG���Q����LH9ill��Ɍ����)y��ؓC��3����(sʜ�_e�Y.������w3�SﭙY��4)�z9*�b`6�MS��F��M�h�г��*���83`Xo�����)RPU-�������iZ�5qܰS�6c[�z���T8W"Ǣ(N�����ۍ⽹`h
�D/�)��oTQ*�w4m/#��� H7�멪�j�% ���ج��������G��':/6��A	��i`����3�[_��ݢy����557��k�����k
���<�n��Lq��q�t�����q��ˣa������7<�{����n^�#}�+W	EO��/ּ_(bZ�嵨�����SUO&m$�4Ά^'�RҮ~�JE]�i3���%��&�҅�C�,���&��G �'�O�?��۩��M�u�W�.���`��xn�[�M��Wws��x�Lk����ЯOk��V����]�}�a͚�Ip��aޖyKZ�M���-���po��59�����\T�1l�}�����'nW���1R�	��$�����:�@�Q�cʑ#�H���'�H�&�I�3� ʟ{�DR����7�Z2&��[�Ň��{�"���Bu��v'D	�#�~�v |5�jxV��Ж~^L�"N~8A4���z�FzK����_�Y�[�)���{��.�CM$��{��p����G�o�&��W�w6�V|�%w��=��3~��T~��2���>��ZRVzUՑ�f��;�!@��sYp<$��!�����])&9�0�mW��}�6�ˆ`W8C�1�3۳�4`�c�"���fd㔾e�I��x���7Se��5��0�=�� }4�)'K�w�U�j6b��l��9EI7B�,Ģ#�>��k@HY!_�;+���6�{��+5RSCC            [remap]

importer="font_data_dynamic"
type="FontFile"
uid="uid://c667k3xp8umin"
path="res://.godot/imported/Kenney Future.ttf-fd1f813a9c064cd591bf3582d7978539.fontdata"
       RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script           local://PackedScene_qjy5y �          PackedScene          	         names "         Node3D    	   variants              node_count             nodes        ��������        ����              conn_count              conns               node_paths              editable_instances              version             RSRC      RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name    content_margin_left    content_margin_top    content_margin_right    content_margin_bottom 	   bg_color    draw_center    skew    border_width_left    border_width_top    border_width_right    border_width_bottom    border_color    border_blend    corner_radius_top_left    corner_radius_top_right    corner_radius_bottom_right    corner_radius_bottom_left    corner_detail    expand_margin_left    expand_margin_top    expand_margin_right    expand_margin_bottom    shadow_color    shadow_size    shadow_offset    anti_aliasing    anti_aliasing_size    script 	   _bundled           local://StyleBoxFlat_fujj4 K         local://PackedScene_oqb66          StyleBoxFlat          �ב>�ב>�ב>  �?	         
                                 mG>mG>mG>  �?                                                      PackedScene          	         names "         Control    layout_mode    anchors_preset    anchor_right    anchor_bottom    grow_horizontal    grow_vertical    Panel2    Panel    clip_contents    custom_minimum_size    anchor_left    anchor_top    offset_bottom    theme_override_styles/panel    metadata/_edit_use_anchors_    Label    text    horizontal_alignment    Label2 $   theme_override_font_sizes/font_size    autowrap_mode 	   Download    Button    	   variants                        �?                  
     @C  @C   ����   aU�>   �X�>   PU?   ��*?     8             (I=   Q�6>      Version Mismatch    Զ-?         @   Download An Update
To Continue?

Game Will Close When Finished.    ��*=     @?   PUu?   G�d?      Download Update       node_count             nodes     �   ��������        ����                                                          ����                                                         ����   	      
                           	      
                                                        ����                                                                    ����                                                                                      ����
                                                                         conn_count              conns               node_paths              editable_instances              version             RSRC               [remap]

path="res://.godot/exported/133200997/export-b12ae16896261643def6ef30add8aed7-Chat.scn"
               [remap]

path="res://.godot/exported/133200997/export-5f8cd2ce024831180dd536a2fbf1e452-ChatMsg.scn"
            [remap]

path="res://.godot/exported/133200997/export-af8e4e7983455cc5bbfdb96e03ee3055-CheckPoint.scn"
         [remap]

path="res://.godot/exported/133200997/export-efe35a19a1e98824c2fb630023711355-CurveNode.res"
          [remap]

path="res://.godot/exported/133200997/export-c6cb43e1a7bc749adbfb5cb805a24b35-curve_visualizer.scn"
   [remap]

path="res://.godot/exported/133200997/export-ab6556a6fc4d67ce1c752ca03758181a-Drone.scn"
              [remap]

path="res://.godot/exported/133200997/export-f17374307c6805240bcd90c9abcb81f6-race_manager.scn"
       [remap]

path="res://.godot/exported/133200997/export-7a4564b24eab0c8b8ee58fb9c950f040-World.scn"
              [remap]

path="res://.godot/exported/133200997/export-e68a5b5581ae8f88ef78f3ea4a322a38-GridmapScene.scn"
       [remap]

path="res://.godot/exported/133200997/export-47f386c24b16dd91f577a4ac668032d1-TestWorld.scn"
          [remap]

path="res://.godot/exported/133200997/export-c2fdec385dbedebf546a6c3d6c465003-UpdatePanel.scn"
        list=Array[Dictionary]([{
"base": &"Node3D",
"class": &"checkpoint",
"icon": "",
"language": &"GDScript",
"path": "res://Game/Objects/CheckPoint.gd"
}, {
"base": &"Node3D",
"class": &"checkpoint_manager",
"icon": "",
"language": &"GDScript",
"path": "res://Game/Objects/CheckpointManager.gd"
}])
        <svg height="128" width="128" xmlns="http://www.w3.org/2000/svg"><rect x="2" y="2" width="124" height="124" rx="14" fill="#363d52" stroke="#212532" stroke-width="4"/><g transform="scale(.101) translate(122 122)"><g fill="#fff"><path d="M105 673v33q407 354 814 0v-33z"/><path d="m105 673 152 14q12 1 15 14l4 67 132 10 8-61q2-11 15-15h162q13 4 15 15l8 61 132-10 4-67q3-13 15-14l152-14V427q30-39 56-81-35-59-83-108-43 20-82 47-40-37-88-64 7-51 8-102-59-28-123-42-26 43-46 89-49-7-98 0-20-46-46-89-64 14-123 42 1 51 8 102-48 27-88 64-39-27-82-47-48 49-83 108 26 42 56 81zm0 33v39c0 276 813 276 814 0v-39l-134 12-5 69q-2 10-14 13l-162 11q-12 0-16-11l-10-65H446l-10 65q-4 11-16 11l-162-11q-12-3-14-13l-5-69z" fill="#478cbf"/><path d="M483 600c0 34 58 34 58 0v-86c0-34-58-34-58 0z"/><circle cx="725" cy="526" r="90"/><circle cx="299" cy="526" r="90"/></g><g fill="#414042"><circle cx="307" cy="532" r="60"/><circle cx="717" cy="532" r="60"/></g></g></svg>
              |VxU�VE   res://Game/Objects/Chat.tscnK�2��@   res://Game/Objects/ChatMsg.tscnJ?h�~H"   res://Game/Objects/CheckPoint.tscnB5?�$z�a!   res://Game/Objects/CurveNode.tresx��H�9	(   res://Game/Objects/curve_visualizer.tscng�Z*�r   res://Game/Objects/Drone.tscnؕ[��6)m$   res://Game/Objects/race_manager.tscn2B:�S�i   res://Game/Objects/World.tscn��ǅ��v   res://Circle.png#�K��5   res://GridmapScene.tscn]<��_gV   res://icon.svg��G�   res://Kenney Future Narrow.ttf���:Ya   res://Kenney Future.ttf`+bL���A   res://TestWorld.tscn�p}��}�   res://UpdatePanel.tscnECFG      application/config/name         ACTIVE     application/run/main_scene(         res://Game/Objects/World.tscn      application/config/features(   "         4.2    GL Compatibility       application/config/icon         res://icon.svg     autoload/GameUpdate         *res://GameUpdate.gd   input/CameraSwitch               deadzone      ?      events              InputEventJoypadButton        resource_local_to_scene           resource_name             device     ����   button_index         pressure          pressed          script         input/ResetPosition               deadzone      ?      events              InputEventJoypadButton        resource_local_to_scene           resource_name             device     ����   button_index         pressure          pressed          script         input/cameratilt_down               deadzone      ?      events              InputEventJoypadButton        resource_local_to_scene           resource_name             device     ����   button_index         pressure          pressed          script         input/cameratilt_up               deadzone      ?      events              InputEventJoypadButton        resource_local_to_scene           resource_name             device     ����   button_index         pressure          pressed          script         input/cameratilt_reset               deadzone      ?      events              InputEventJoypadButton        resource_local_to_scene           resource_name             device     ����   button_index         pressure          pressed          script         input/vsync�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   V   	   key_label             unicode    v      echo          script         input/showsettings|              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode    @ 	   key_label             unicode           echo          script            InputEventJoypadButton        resource_local_to_scene           resource_name             device     ����   button_index         pressure          pressed          script         input/start_race�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   K   	   key_label             unicode    k      echo          script         input/LeftClick�              deadzone      ?      events              InputEventMouseButton         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          button_mask           position              global_position               factor       �?   button_index         canceled          pressed           double_click          script         input/RightClick�              deadzone      ?      events              InputEventMouseButton         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          button_mask           position              global_position               factor       �?   button_index         canceled          pressed           double_click          script      #   rendering/renderer/rendering_method         gl_compatibility*   rendering/renderer/rendering_method.mobile         gl_compatibility      