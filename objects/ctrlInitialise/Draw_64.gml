/// @desc Draw the splash screen background and log

var _i = 0;
repeat (array_length(initLog))
{
    draw_set_font(fntUI);
    draw_text(initLogX, initLogY + (_i * initLogYSpace), initLog[_i]);
    _i++;
}

draw_sprite(graBactaWave, 0, 40, 40);