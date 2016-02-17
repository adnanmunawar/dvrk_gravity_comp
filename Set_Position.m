%% Original Authors: Amaid Zia, Brandon Boos, Junius Santoso, Alex Rutfield, Nuttaworn Sujumonong
%% Worcester Polytechnic Institute
%% Maintainer: Adnan Munawar
%% Email: amunawar@wpi.edu
%% Automation in Interventional Medicine Labs (AIM Labs), WPI, MA, 01609
function [q_values] = Set_Position(set_position_msg, q_values)
%Use to set the position to begin gravity compensation tuning and returns
%position
    msg = rosmessage(set_position_msg);
    msg.Position = q_values;
    send(set_position_msg, msg);
end

