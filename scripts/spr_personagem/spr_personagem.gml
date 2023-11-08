// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

//Colisão

function scr_personagem_colisao(){
			
	if !place_meeting(x, y + 1, obj_parede){
		vveloc += lerp(0.1, gravidade, 0.005);
	}else{
		
	}
	
	if cima && jump > 0{
			vveloc = -3;	
			jump--;
		}
	
	if place_meeting(x + hveloc, y, obj_parede){
		while !place_meeting(x + sign(hveloc), y, obj_parede){
			x += sign(hveloc);
		}
		hveloc = 0;
		if (direita && !place_meeting(x, y + 1, obj_parede)){
			vveloc = 0.5;
			sprite_index = spr_personagem_agarra_direita;
			jump = 2;
			dash_perm = true;
		}else if (esquerda && !place_meeting(x, y + 1, obj_parede)){
			vveloc = 0.5;
			sprite_index = spr_personagem_agarra_esquerda;
			jump = 2;
			dash_perm = true;
		}
	}
	x += hveloc;
	
	if place_meeting(x, y + vveloc, obj_parede){
		while !place_meeting(x, y + sign(vveloc) , obj_parede){
			y += sign(vveloc);
		}
		vveloc = 0;
		dash_perm = true;
		jump = 2;
	}
	y += vveloc;
}

//Movimentação & Comandos

function scr_personagem_movimentacao(){
	direita = keyboard_check(ord("D"));
	esquerda = keyboard_check(ord("A"));
	baixo = keyboard_check(ord("S"));
	cima_olhar = keyboard_check(ord("W"));
	cima = keyboard_check_pressed(vk_space);
	ataque = keyboard_check(ord("J"));
	esquiva = keyboard_check(ord("K"));
	
	hveloc = (direita - esquerda) * veloc;
	
	if direita{
		direc = 0;	
	}
	else if esquerda{
		direc = 1;
	}
	
	if !place_meeting(x, y + 1, obj_parede) && direc == 0 {
    // Pulo para a direita
    sprite_index = spr_personagem_pulando_direita;
    
}else if !place_meeting(x, y + 1, obj_parede) && direc == 1{
    // Pulo para a esquerda
    sprite_index = spr_personagem_pulando_esquerda;
    
}else{
    // No chão ou parado
    if (direita){
        sprite_index = spr_personagem_andando_direita;
    }else if (esquerda){
        sprite_index = spr_personagem_andando_esquerda;
    }else{
        if (direc == 0){
            sprite_index = spr_personagem_parado_direita;
        }else if (direc == 1){
            sprite_index = spr_personagem_parado_esquerda;
        }
    }
}

if(ataque && atacar == true){
	alarm[3] = 40;
	estado = scr_personagem_atacando;
	atacar = false;
}

if(esquiva){
	if alarm[1] <= 0 && dash_perm == true{
		estado = scr_personagem_esquiva;	
		alarm[0] = 20;
		alarm[1] = 25;
		if !place_meeting(x, y + 1, obj_parede){	
			dash_perm = false;
		}
	}
}

if (vveloc > 0) {
	if direc == 0{
		sprite_index = spr_personagem_pulando_direita;	
	}else if direc == 1{
		sprite_index = spr_personagem_pulando_esquerda;
	}
	
	
    if (image_index != 1) {
        image_index = 1;
    }
} else if (vveloc < 0) {
	
	if direc == 0{
		sprite_index = spr_personagem_pulando_direita;	
	}else if direc == 1{
		sprite_index = spr_personagem_pulando_esquerda;
	}
	
    if (image_index != 0) {
        image_index = 0;
    }
}
	scr_personagem_colisao();
}

//Ataque

function scr_personagem_atacando(){
	
	if ataque && baixo {
		instance_create_layer(x, y, "Instances", obj_hitbox2_personagem);
	}else{
	
		if (ataque && direc == 0) {
		//sprite_index = spr_personagem_atacando_direita;
		instance_create_layer(x + 10, y, "Instances", obj_hitbox_personagem);
		}else if (ataque && direc == 1) {
			//sprite_index = spr_personagem_atacando_esquerda;
			instance_create_layer(x - 110, y, "Instances", obj_hitbox_personagem);
		}
	}
	
	//if fim_da_animacao(){
		estado = scr_personagem_movimentacao;
	//}
	
	scr_personagem_colisao();
	
}

//Esquiva

function scr_personagem_esquiva(){
	
scr_personagem_colisao();
if direc == 0 {
	sprite_index = spr_personagem_esquivando_direita;
    hveloc = lengthdir_x(dash_veloc, dash_dir);
	vveloc = 0;
	
} else if direc == 1 {
	sprite_index = spr_personagem_esquivando_esquerda;
    hveloc = -lengthdir_x(dash_veloc, dash_dir);
	vveloc = 0;
}

var _inst = instance_create_layer(x, y, "Instances", obj_dash);
_inst.sprite_index = sprite_index;
_inst.image_index = image_index - 1;
}

function scr_personagem_pogo(){
		vveloc = -3;
		jump = 1;
		dash_perm = true;
		estado = scr_personagem_movimentacao;
}

