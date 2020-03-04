function [I_blurred] = rotate_blur_image(I, th_max)
    I_blurred = I;
    for th = linspace(0,th_max,100)
        I_blurred = I_blurred + imrotate(I, th, 'nearest', 'crop');
    end
end