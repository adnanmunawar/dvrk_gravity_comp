%% Original Authors: Amaid Zia, Brandon Boos, Junius Santoso, Alex Rutfield, Nuttaworn Sujumonong
%% Worcester Polytechnic Institute
%% Maintainer: Adnan Munawar
%% Email: amunawar@wpi.edu
%% Automation in Interventional Medicine Labs (AIM Labs), WPI, MA, 01609
 sub_pos = rossubscriber('/dvrk_mtm/joint_position_current');
 pub_tor = rospublisher('/dvrk_mtm/set_joint_effort');
 g = 9.81;
 position = Get_Position(sub_pos);
 position_error = zeros(8,100);
 
  dynamic_param = [0.0414
                  -0.0192
                   0.0328
                   0.0095
                  -0.0033
                  -0.0003
                  -0.0071
                  -0.0188
                  -0.0015
                  -0.0003
                  -0.0001
                   0.0005];

for i = 1:1000
  qs = Get_Position(sub_pos);
  q1 = qs(1);
  q2 = qs(2);
  q3 = qs(3);
  q4 = qs(4);
  q5 = qs(5);
  q6 = qs(6);
  q7 = qs(7);
  
  Regressor_Matrix =             [         0,          0,                                     0,                                     0,                                                                                                                             0,                                                                                                                                                                                                                                     0,                                                     0,                                                     0,                                                                                                                             0,                                                                                                                                                                                                                                     0,                                                                                                                                                                                                                                                                                                                                                                                                                                                     0,                                                                                                                                                                                                                                                                                                                                                                                                                                                     0
                                   g*sin(q2), -g*cos(q2), g*cos(q2)*cos(q3) - g*sin(q2)*sin(q3), g*cos(q2)*sin(q3) + g*cos(q3)*sin(q2), g*cos(q4)*sin(q2)*sin(q3)*sin(q5) - g*cos(q3)*cos(q5)*sin(q2) - g*cos(q2)*cos(q3)*cos(q4)*sin(q5) - g*cos(q2)*cos(q5)*sin(q3), g*sin(q2)*sin(q3)*sin(q4)*sin(q6) - g*cos(q2)*cos(q6)*sin(q3)*sin(q5) - g*cos(q3)*cos(q6)*sin(q2)*sin(q5) - g*cos(q2)*cos(q3)*sin(q4)*sin(q6) - g*cos(q4)*cos(q5)*cos(q6)*sin(q2)*sin(q3) + g*cos(q2)*cos(q3)*cos(q4)*cos(q5)*cos(q6), g*cos(q2)*cos(q3)*cos(q4) - g*cos(q4)*sin(q2)*sin(q3), g*cos(q2)*cos(q3)*sin(q4) - g*sin(q2)*sin(q3)*sin(q4), g*cos(q2)*sin(q3)*sin(q5) + g*cos(q3)*sin(q2)*sin(q5) - g*cos(q2)*cos(q3)*cos(q4)*cos(q5) + g*cos(q4)*cos(q5)*sin(q2)*sin(q3), g*cos(q6)*sin(q2)*sin(q3)*sin(q4) - g*cos(q2)*cos(q3)*cos(q6)*sin(q4) + g*cos(q2)*sin(q3)*sin(q5)*sin(q6) + g*cos(q3)*sin(q2)*sin(q5)*sin(q6) + g*cos(q4)*cos(q5)*sin(q2)*sin(q3)*sin(q6) - g*cos(q2)*cos(q3)*cos(q4)*cos(q5)*sin(q6), g*cos(q2)*cos(q5)*sin(q3)*sin(q7) + g*cos(q3)*cos(q5)*sin(q2)*sin(q7) + g*cos(q2)*cos(q3)*cos(q4)*sin(q5)*sin(q7) + g*cos(q6)*cos(q7)*sin(q2)*sin(q3)*sin(q4) + g*cos(q2)*cos(q7)*sin(q3)*sin(q5)*sin(q6) + g*cos(q3)*cos(q7)*sin(q2)*sin(q5)*sin(q6) - g*cos(q4)*sin(q2)*sin(q3)*sin(q5)*sin(q7) - g*cos(q2)*cos(q3)*cos(q6)*cos(q7)*sin(q4) - g*cos(q2)*cos(q3)*cos(q4)*cos(q5)*cos(q7)*sin(q6) + g*cos(q4)*cos(q5)*cos(q7)*sin(q2)*sin(q3)*sin(q6), g*cos(q4)*cos(q7)*sin(q2)*sin(q3)*sin(q5) - g*cos(q3)*cos(q5)*cos(q7)*sin(q2) - g*cos(q2)*cos(q3)*cos(q6)*sin(q4)*sin(q7) - g*cos(q2)*cos(q5)*cos(q7)*sin(q3) + g*cos(q6)*sin(q2)*sin(q3)*sin(q4)*sin(q7) + g*cos(q2)*sin(q3)*sin(q5)*sin(q6)*sin(q7) + g*cos(q3)*sin(q2)*sin(q5)*sin(q6)*sin(q7) - g*cos(q2)*cos(q3)*cos(q4)*cos(q7)*sin(q5) + g*cos(q4)*cos(q5)*sin(q2)*sin(q3)*sin(q6)*sin(q7) - g*cos(q2)*cos(q3)*cos(q4)*cos(q5)*sin(q6)*sin(q7)
                                           0,          0, g*cos(q2)*cos(q3) - g*sin(q2)*sin(q3), g*cos(q2)*sin(q3) + g*cos(q3)*sin(q2), g*cos(q4)*sin(q2)*sin(q3)*sin(q5) - g*cos(q3)*cos(q5)*sin(q2) - g*cos(q2)*cos(q3)*cos(q4)*sin(q5) - g*cos(q2)*cos(q5)*sin(q3), g*sin(q2)*sin(q3)*sin(q4)*sin(q6) - g*cos(q2)*cos(q6)*sin(q3)*sin(q5) - g*cos(q3)*cos(q6)*sin(q2)*sin(q5) - g*cos(q2)*cos(q3)*sin(q4)*sin(q6) - g*cos(q4)*cos(q5)*cos(q6)*sin(q2)*sin(q3) + g*cos(q2)*cos(q3)*cos(q4)*cos(q5)*cos(q6), g*cos(q2)*cos(q3)*cos(q4) - g*cos(q4)*sin(q2)*sin(q3), g*cos(q2)*cos(q3)*sin(q4) - g*sin(q2)*sin(q3)*sin(q4), g*cos(q2)*sin(q3)*sin(q5) + g*cos(q3)*sin(q2)*sin(q5) - g*cos(q2)*cos(q3)*cos(q4)*cos(q5) + g*cos(q4)*cos(q5)*sin(q2)*sin(q3), g*cos(q6)*sin(q2)*sin(q3)*sin(q4) - g*cos(q2)*cos(q3)*cos(q6)*sin(q4) + g*cos(q2)*sin(q3)*sin(q5)*sin(q6) + g*cos(q3)*sin(q2)*sin(q5)*sin(q6) + g*cos(q4)*cos(q5)*sin(q2)*sin(q3)*sin(q6) - g*cos(q2)*cos(q3)*cos(q4)*cos(q5)*sin(q6), g*cos(q2)*cos(q5)*sin(q3)*sin(q7) + g*cos(q3)*cos(q5)*sin(q2)*sin(q7) + g*cos(q2)*cos(q3)*cos(q4)*sin(q5)*sin(q7) + g*cos(q6)*cos(q7)*sin(q2)*sin(q3)*sin(q4) + g*cos(q2)*cos(q7)*sin(q3)*sin(q5)*sin(q6) + g*cos(q3)*cos(q7)*sin(q2)*sin(q5)*sin(q6) - g*cos(q4)*sin(q2)*sin(q3)*sin(q5)*sin(q7) - g*cos(q2)*cos(q3)*cos(q6)*cos(q7)*sin(q4) - g*cos(q2)*cos(q3)*cos(q4)*cos(q5)*cos(q7)*sin(q6) + g*cos(q4)*cos(q5)*cos(q7)*sin(q2)*sin(q3)*sin(q6), g*cos(q4)*cos(q7)*sin(q2)*sin(q3)*sin(q5) - g*cos(q3)*cos(q5)*cos(q7)*sin(q2) - g*cos(q2)*cos(q3)*cos(q6)*sin(q4)*sin(q7) - g*cos(q2)*cos(q5)*cos(q7)*sin(q3) + g*cos(q6)*sin(q2)*sin(q3)*sin(q4)*sin(q7) + g*cos(q2)*sin(q3)*sin(q5)*sin(q6)*sin(q7) + g*cos(q3)*sin(q2)*sin(q5)*sin(q6)*sin(q7) - g*cos(q2)*cos(q3)*cos(q4)*cos(q7)*sin(q5) + g*cos(q4)*cos(q5)*sin(q2)*sin(q3)*sin(q6)*sin(q7) - g*cos(q2)*cos(q3)*cos(q4)*cos(q5)*sin(q6)*sin(q7)
                                           0,          0,                                     0,                                     0,                                                                                                g*sin(q2 + q3)*sin(q4)*sin(q5),                                                                                                                                                                           -g*sin(q2 + q3)*(cos(q4)*sin(q6) + cos(q5)*cos(q6)*sin(q4)),                               -g*sin(q2 + q3)*sin(q4),                                g*sin(q2 + q3)*cos(q4),                                                                                                g*sin(q2 + q3)*cos(q5)*sin(q4),                                                                                                                                                                           -g*sin(q2 + q3)*(cos(q4)*cos(q6) - cos(q5)*sin(q4)*sin(q6)),                                                                                                                                                                                                                                                                                                                                                 -g*sin(q2 + q3)*(sin(q4)*sin(q5)*sin(q7) + cos(q4)*cos(q6)*cos(q7) - cos(q5)*cos(q7)*sin(q4)*sin(q6)),                                                                                                                                                                                                                                                                                                                                                  g*sin(q2 + q3)*(cos(q7)*sin(q4)*sin(q5) - cos(q4)*cos(q6)*sin(q7) + cos(q5)*sin(q4)*sin(q6)*sin(q7))
                                           0,          0,                                     0,                                     0,    -g*(cos(q2)*cos(q3)*sin(q5) - sin(q2)*sin(q3)*sin(q5) + cos(q2)*cos(q4)*cos(q5)*sin(q3) + cos(q3)*cos(q4)*cos(q5)*sin(q2)),                                                                            -g*(cos(q5)*cos(q6)*sin(q2)*sin(q3) - cos(q2)*cos(q3)*cos(q5)*cos(q6) + cos(q2)*cos(q4)*cos(q6)*sin(q3)*sin(q5) + cos(q3)*cos(q4)*cos(q6)*sin(q2)*sin(q5)),                                                     0,                                                     0,     g*(cos(q5)*sin(q2)*sin(q3) - cos(q2)*cos(q3)*cos(q5) + cos(q2)*cos(q4)*sin(q3)*sin(q5) + cos(q3)*cos(q4)*sin(q2)*sin(q5)),                                                                             g*(cos(q5)*sin(q2)*sin(q3)*sin(q6) - cos(q2)*cos(q3)*cos(q5)*sin(q6) + cos(q2)*cos(q4)*sin(q3)*sin(q5)*sin(q6) + cos(q3)*cos(q4)*sin(q2)*sin(q5)*sin(q6)),                                                                                                     g*(cos(q2)*cos(q3)*sin(q5)*sin(q7) - sin(q2)*sin(q3)*sin(q5)*sin(q7) - cos(q2)*cos(q3)*cos(q5)*cos(q7)*sin(q6) + cos(q2)*cos(q4)*cos(q5)*sin(q3)*sin(q7) + cos(q3)*cos(q4)*cos(q5)*sin(q2)*sin(q7) + cos(q5)*cos(q7)*sin(q2)*sin(q3)*sin(q6) + cos(q2)*cos(q4)*cos(q7)*sin(q3)*sin(q5)*sin(q6) + cos(q3)*cos(q4)*cos(q7)*sin(q2)*sin(q5)*sin(q6)),                                                                                                    -g*(cos(q2)*cos(q3)*cos(q7)*sin(q5) - cos(q7)*sin(q2)*sin(q3)*sin(q5) + cos(q2)*cos(q4)*cos(q5)*cos(q7)*sin(q3) + cos(q3)*cos(q4)*cos(q5)*cos(q7)*sin(q2) + cos(q2)*cos(q3)*cos(q5)*sin(q6)*sin(q7) - cos(q5)*sin(q2)*sin(q3)*sin(q6)*sin(q7) - cos(q2)*cos(q4)*sin(q3)*sin(q5)*sin(q6)*sin(q7) - cos(q3)*cos(q4)*sin(q2)*sin(q5)*sin(q6)*sin(q7))
                                           0,          0,                                     0,                                     0,                                                                                                                             0,        -g*(cos(q2)*cos(q6)*sin(q3)*sin(q4) + cos(q3)*cos(q6)*sin(q2)*sin(q4) + cos(q2)*cos(q3)*sin(q5)*sin(q6) - sin(q2)*sin(q3)*sin(q5)*sin(q6) + cos(q2)*cos(q4)*cos(q5)*sin(q3)*sin(q6) + cos(q3)*cos(q4)*cos(q5)*sin(q2)*sin(q6)),                                                     0,                                                     0,                                                                                                                             0,        -g*(cos(q2)*cos(q3)*cos(q6)*sin(q5) - cos(q2)*sin(q3)*sin(q4)*sin(q6) - cos(q3)*sin(q2)*sin(q4)*sin(q6) - cos(q6)*sin(q2)*sin(q3)*sin(q5) + cos(q2)*cos(q4)*cos(q5)*cos(q6)*sin(q3) + cos(q3)*cos(q4)*cos(q5)*cos(q6)*sin(q2)),                                                                                                                                                                        -g*(cos(q2)*cos(q3)*cos(q6)*cos(q7)*sin(q5) - cos(q2)*cos(q7)*sin(q3)*sin(q4)*sin(q6) - cos(q3)*cos(q7)*sin(q2)*sin(q4)*sin(q6) - cos(q6)*cos(q7)*sin(q2)*sin(q3)*sin(q5) + cos(q2)*cos(q4)*cos(q5)*cos(q6)*cos(q7)*sin(q3) + cos(q3)*cos(q4)*cos(q5)*cos(q6)*cos(q7)*sin(q2)),                                                                                                                                                                        -g*(cos(q2)*cos(q3)*cos(q6)*sin(q5)*sin(q7) - cos(q2)*sin(q3)*sin(q4)*sin(q6)*sin(q7) - cos(q3)*sin(q2)*sin(q4)*sin(q6)*sin(q7) - cos(q6)*sin(q2)*sin(q3)*sin(q5)*sin(q7) + cos(q2)*cos(q4)*cos(q5)*cos(q6)*sin(q3)*sin(q7) + cos(q3)*cos(q4)*cos(q5)*cos(q6)*sin(q2)*sin(q7))
                                           0,          0,                                     0,                                     0,                                                                                                                             0,                                                                                                                                                                                                                                     0,                                                     0,                                                     0,                                                                                                                             0,                                                                                                                                                                                                                                     0,                                                                                                                                                                                                                                                                                                                                                                                                                                                     0,                                                                                                                                                                                                                                                                                                                                                                                                                                                    0]; %g*(cos(q5)*cos(q7)*sin(q2)*sin(q3) - cos(q2)*cos(q3)*cos(q5)*cos(q7) + cos(q2)*cos(q4)*cos(q7)*sin(q3)*sin(q5) + cos(q3)*cos(q4)*cos(q7)*sin(q2)*sin(q5) + cos(q2)*cos(q6)*sin(q3)*sin(q4)*sin(q7) + cos(q3)*cos(q6)*sin(q2)*sin(q4)*sin(q7) + cos(q2)*cos(q3)*sin(q5)*sin(q6)*sin(q7) - sin(q2)*sin(q3)*sin(q5)*sin(q6)*sin(q7) + cos(q2)*cos(q4)*cos(q5)*sin(q3)*sin(q6)*sin(q7) + cos(q3)*cos(q4)*cos(q5)*sin(q2)*sin(q6)*sin(q7)),                -g*(cos(q2)*cos(q3)*cos(q5)*sin(q7) - cos(q5)*sin(q2)*sin(q3)*sin(q7) + cos(q2)*cos(q6)*cos(q7)*sin(q3)*sin(q4) + cos(q3)*cos(q6)*cos(q7)*sin(q2)*sin(q4) + cos(q2)*cos(q3)*cos(q7)*sin(q5)*sin(q6) - cos(q2)*cos(q4)*sin(q3)*sin(q5)*sin(q7) - cos(q3)*cos(q4)*sin(q2)*sin(q5)*sin(q7) - cos(q7)*sin(q2)*sin(q3)*sin(q5)*sin(q6) + cos(q2)*cos(q4)*cos(q5)*cos(q7)*sin(q3)*sin(q6) + cos(q3)*cos(q4)*cos(q5)*cos(q7)*sin(q2)*sin(q6))];


  Torques = Regressor_Matrix*dynamic_param;
  %Torques(5:7) = zeros(1, 3);
  Set_Torque(pub_tor, Torques);
  pause(0.01);
  position_error(1:8,i) = Get_Position(sub_pos)-position;
  %display('running')
end

Plot_Errors(position_error);
