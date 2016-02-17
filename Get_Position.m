%% Original Authors: Amaid Zia, Brandon Boos, Junius Santoso, Alex Rutfield, Nuttaworn Sujumonong
%% Worcester Polytechnic Institute
%% Maintainer: Adnan Munawar
%% Email: amunawar@wpi.edu
%% Automation in Interventional Medicine Labs (AIM Labs), WPI, MA, 01609
function [position] = Get_Position(sub_pos)
%Use to get the torque values
    msg = receive(sub_pos);
    position = msg.Position;
end
