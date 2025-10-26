%Project:Group 3
%Concrete Mix Design using ACI and British Method and cost estimation
%and Sieve analysis of Coarse and Fine Aggregate
clc;clear;
disp('mix design')
fprintf('Welcome\n')
fprintf('\nMethod selection\n')
disp('select 1 for ACI or 2 for British Method')
method=input('selection choice = ');

%ACI Method For Concrete Mix Design
%Input:slump,Target mean strength
%Coarse aggregate specification and gradation
%Fine aggregate specification and gradation
%Bulk specific gravity and adsorption of fine and coarse aggregate
% Mixing water requirements
%Relationship between strength vs. w/c-ratio
%Specific gravity of cement
%Optimum combination of aggregate to meet maximum density grading

%output:mix ratio
if method==1
fprintf('\n.......ACI Method for Mix Design.......\n')
%1st step: choice of slump
fprintf('\n𝐒𝐭𝐞𝐩 𝟏\n')
disp('slump choice (minimum 25 mm / 1 inch for all type of construction)')
disp('select 1 for mm unit or 2 for inch unit')
choice1=input(' = ');
fprintf('\n')
disp('type 1 for building column/Beam/Reinforced wall, type 2 for slab/footing/substructure wall')
s=input('type of construction = ');
if s==1
  slump=input('slump (maximum 100mm/4 inch) = '); %According to table
else 
slump=input('slump (maximum 75mm/3 inch) = ');
end
if choice1 == 2
    slump= 25*slump; % converting inch to mm
end

%2nd step : Choice of maximum size of aggregate
fprintf('\n𝐒𝐭𝐞𝐩 𝟐\n')
disp('Input maximum size of aggregate')
disp('select 1 for mm unit or 2 for inch unit')
choice2=input(' = ');
agg=input('maximum size of aggregate (maximum 150mm /6 inch) = ');
if choice2 == 2
    agg= 25*agg; % converting inch to mm
end

%Step 3: Estimating mixing water and air content
% using linear interpolation to get required air percentage
% and Required mixing water in kg/m^3 from table
fprintf('\n𝐒𝐭𝐞𝐩 𝟑\n')
%Following values are from table
mixwater1= [ 207 199 190 179 166 154 130 133];
mixwater2= [ 228 216 205 193 181 169 145 124];
mixwater3= [ 181 175 168 160 150 142 122 107];
mixwater4=[202 193 184 175 165 157 133 119];
air1= [3 2.5 2 1.5 1 .5 .3 .2];
air2=4.5:-.5:1;
air3=[6 5.5 5 4.5 4.5 4 3.5 3];
air4= [7.5 7 6 6 5.5 5 4.5 4];
agg_size=[9.5 12.5 19 25 37.5 50 75 150];
disp('choose type of concrete: 1 for non air-entrained, 2 for air-entrained')
choice3=input('=');

% graph generating
figure
subplot(221)
plot(agg_size,mixwater1,'r',agg_size,mixwater2,'g')
xlabel('Maximum Aggregate Size (mm)'),ylabel('Mixing Water (kg/m^3)')
legend('for 25mm<slump<50mm','for 50mm<slump<100mm')
title('Estimation of Water Content for Non Air-Entrained Concrete')
subplot(222)
plot(agg_size,air1,'m')
xlabel('Maximum Aggregate Size (mm)'),ylabel('Air Percentage (%)')
legend('for non air-entrained concrete')
title('Estimation of Air Percentage for Non Air-Entrained Concrete')
subplot(223)
plot(agg_size,mixwater3,'r',agg_size,mixwater4,'g')
xlabel('Maximum Aggregate Size (mm)'),ylabel('Mixing Water (kg/m^3)')
legend('for 25mm<slump<50mm','for 50mm<slump<100mm')
title('Estimation of Water Content for Air-Entrained Concrete')
subplot(224)
plot(agg_size,air2,'m',agg_size,air3,agg_size,air4)
xlabel('Maximum Aggregate Size (mm)'),ylabel('Air Percentage (%)')
legend('mild exposure','moderate exposure','severe exposure')
title('Estimation of Air Percentage for Air-Entrained Concrete')

%for non air-entrained
if choice3==1
required_air= interp1(agg_size,air1,agg,'linear'); 
if (slump>=25 && slump <= 50 )
 required_water= interp1(agg_size,mixwater1,agg,'linear');
elseif (slump>50 && slump <= 100 )
        required_water= interp1(agg_size,mixwater2,agg,'linear');
end
end
%for air-entrained
if choice3==2
    %level of exposure
    disp('select level of exposure')
    disp('type 1 for mild exposure, 2 for moderate ,3 for severe')
    choice4=input('=');
    if choice4==1 %mild exposure
required_air= interp1(agg_size,air2,agg,'linear'); 
    elseif choice4==2 %moderate exposure
        required_air= interp1(agg_size,air3,agg,'linear'); 
    elseif choice4==3 %severe exposure
        required_air= interp1(agg_size,air4,agg,'linear'); 
    end
if (slump>=25 && slump <= 50 )
 required_water= interp1(agg_size,mixwater3,agg,'linear');
elseif (slump>50 && slump <= 100 )
        required_water= interp1(agg_size,mixwater4,agg,'linear');
end
end
disp('Step 3 results:')
t1=table([required_water,required_air]','VariableNames',{'Amount in kg/m^3'},'RowNames',{'Required Water','Estimated Air'});
disp(t1)

%Step 4: Selection of w/c ratio
% Using compressive strength and air condition to find the water/cement ratio from Table.
%required data : target mean strength
fprintf('\n𝐒𝐭𝐞𝐩 𝟒\n')
disp('Input Target Mean Strength:')
disp('select unit:input 1 for MPa, 2 for Psi')
choice5=input(' = ');
strength=input('target mean strength (maximum 36 MPa) =');
%converting to MPa unit
 if choice5 == 2
    strength=strength/145;
 end
% Overdesign necessary to meet strength requirements
 if (strength<=21)
     Required_average_strength=strength+7;
 elseif (strength>21 && strength<=35)
         Required_average_strength=strength+8.5;
 elseif (strength>35)
         Required_average_strength=1.1*strength+5;
 end
 %Relationship between water to cement ratio and compressive strength of concrete
 ST=15:5:45;
WC1= [.79 .69 .61 .54 .47 .42 .38];
WC2= [.7 .6  .52 .45 .39 .34 .3];
% graph generating
figure
plot(ST,WC1,'r',ST,WC2,'g')
xlabel('Compressive Strength at 28 days (MPa)'),ylabel('w/c ratio by mass')
legend('for non air-entrained concrete','for air-entrained concrete')
title('Relationship Between Water/Cement Ratio and Compressive Strength of Concrete')

if choice3==1 %for non air-entrained concrete
wc_ratio=interp1(ST,WC1,Required_average_strength,'linear');
elseif choice3==2 %for air-entrained concrete
    wc_ratio=interp1(ST,WC2,Required_average_strength,'linear');
end
 fprintf('Step 4 Results:\n')
t2=table([Required_average_strength,wc_ratio]','VariableNames',{'Amounts'},'RowNames',{'Compressive Strength (MPa)','Estimated W/C Ratio'});
disp(t2)

%Step 5: Determination of cement content
fprintf('𝐒𝐭𝐞𝐩 𝟓\n')
cement=required_water/wc_ratio; %Cement content in kg/m3
fprintf('step 5 Result:\n')
t3=table(cement,'VariableNames',{'Amount in kg/m^3'},'RowNames',{'Cement Content'});
disp(t3)
 
%Step 6: Estimating coarse aggregate content
fprintf('𝐒𝐭𝐞𝐩 6\n')
unit_CA=input('Unit Weight of coarse aggregate in kg/m^3=');
 disp('Input FM of Fine Aggregate (range 2.4 to 3.0)')
 FM=input('Fineness Modulus =');
%Using FM of fine aggregate and maximum aggregate size to find 
% the per unit volume of dry-rodded (OD) coarse aggregate from Table 3
 fm= [2.4 2.6 2.8 3];
 vol_CA=[.5 .48 .46 .44;
     .59 .57 .55 .53;
     .66 .64 .62 .6;
     .71 .69 .67 .65;
     .75 .73 .71 .69;
     .78 .76 .74 .72;
     .82 .8 .78 .76;
     .87 .85 .83 .81];
 if agg<= 9.5
     i=1; %row index
 elseif (agg> 9.5 && agg<=12.5)
     i=2;
     elseif (agg> 12.5 && agg<=19)
     i=3;
     elseif (agg> 19 && agg<=25)
     i=4;
     elseif (agg>25 && agg<=37.5)
     i=5;
     elseif (agg> 37.5 && agg<=50)
     i=6;
     elseif (agg>50 && agg<=75)
     i=7;
     elseif (agg> 75 && agg<150)
     i=8;
 end
 volm_CA=vol_CA(i,:);

 figure
plot(fm,volm_CA)
xlabel('Fineness Moduli of Fine aggregate'),ylabel('Bulk volume of CA per unit volume of concrete')
title('Relationship Between Maximum Aggregate Size,FM of FA and Bulk volume of CA','Color','b')

coarse_agg_volume=interp1(fm,volm_CA,FM,"linear");
 %OD weight of CA = OD rodded volume * bulk unit weight
 OD_weightCA= coarse_agg_volume*unit_CA;
fprintf('step 6 result:\n')
t4=table(OD_weightCA,'VariableNames',{'Amount in kg/m^3'},'RowNames',{'OD Weight of CA'});
disp(t4)

 %Step 7: Estimating fine aggregate content
AC_CA =input('Absorption Capacity of CA (%) =');
AC_FA=input('Absorption Capacity of FA (%) =');

fprintf('\nstep 7:Estimating Fine Aggregate Content\n')
 disp('choose 1 for Weight basis ,2 for Volume basis')
 choice6=input('=');

%weight basis
if choice6==1
%Table 6: First estimate of density (unit weight) of fresh concrete
concrete1=[2280 2310 2345 2380 2410 2445 2490 2530];
concrete2=[220 2230 2275 2290 2350 2345 2405 2435];
if choice3==1 %for non air-entrained concrete
concrete_density=interp1(agg_size,concrete1,agg,"linear");
elseif choice3==2 %for air-entrained concrete
 concrete_density=interp1(agg_size,concrete2,agg,"linear");
end

figure
plot(agg_size,concrete1,'g',agg_size,concrete2)
title('Estimation of Concrete Unit Mass')
xlabel('maximum size of aggregate (mm)'),ylabel('concrete unit mass (kg/m^3)')
legend('for non air-entrained concrete','for air-entrained concrete')

%SSD weight of CA = OD weight of CA * (1 + absorption capacity (%)/100)
SSD_CA= OD_weightCA*(1+(AC_CA/100));
%FA mass(SSD) = concrete density – water mass – cement mass – CA mass (SSD)
SSD_FA= concrete_density-required_water-cement-SSD_CA;
OD_weightFA= SSD_FA/(1+(AC_FA/100));
fprintf('Results for Weight Basis Method:\n')
t5=table([concrete_density,SSD_FA]','VariableNames',{'Amount in kg/m^3'},'RowNames',{'Concrete Density','FA mass(SSD)'});
disp(t5)
end

%Volume basis: (more accurate method)
%𝑉𝑜𝑙𝑢𝑚𝑒 𝑜𝑓 𝑊𝑎𝑡𝑒𝑟 + 𝐶𝑒𝑚𝑒𝑛𝑡 + 𝐹𝐴 + 𝐶𝐴 + 𝐴𝑖𝑟 = 𝑉𝑜𝑙𝑢𝑚𝑒 𝑜𝑓 𝑐𝑜𝑛𝑐𝑟𝑒𝑡𝑒
%𝑣𝑜𝑙𝑢𝑚𝑒 =𝑤𝑒𝑖𝑔ℎ𝑡/(s𝑝. 𝑔𝑟𝑎𝑣𝑖𝑡𝑦 ∗ 𝑑𝑒𝑛𝑠𝑖𝑡𝑦𝑤𝑎𝑡𝑒r)
if choice6==2
BSG_CA =input('Bulk Specific gravity of CA =');
BSG_FA =input('Bulk Specific gravity of FA =');
SG_cem =input('Specific gravity of cement =');
volm_FA= 1-required_air/100-(OD_weightCA/(BSG_CA*1000))-(required_water/1000)-(cement/(SG_cem*1000));
OD_weightFA=volm_FA*BSG_FA*1000;
fprintf('\nResults for Volume Basis Method:\n')
t5=table(OD_weightFA,'VariableNames',{'Amount in kg/m^3'},'RowNames',{'OD Weight of FA'});
disp(t5)
 end

 % Step 8: Adjustment for aggregate moisture
 fprintf('step 8\n')
 %𝑾𝒇𝒊𝒆𝒍𝒅 = 𝑾𝑶𝑫 ∗ (𝟏 + 𝑴𝒐𝒊𝒔𝒕. 𝒄𝒐𝒏𝒕. )
 fprintf('\n')
disp('Input Moisture Contents (%)')
MC_CA =input('moisture content of CA(%) =');
MC_FA=input('moisture content of FA (%) =');
field_CA= OD_weightCA*(1+(MC_CA/100));
field_FA= OD_weightFA*(1+(MC_FA/100));

%Water Adjustment :∆𝑾𝒘𝒂𝒕𝒆𝒓 = 𝑾𝑶𝑫 ∗ 𝑺𝒖𝒓𝒇𝒄. 𝒎𝒐𝒊𝒔𝒕.
adjusted_water= required_water -(OD_weightCA*((MC_CA-AC_CA)/100))-(OD_weightFA*((MC_FA-AC_FA)/100));
free_water_content=adjusted_water;
fine_agg_content=field_FA;
coarse_agg_content=field_CA;
end  %end of ACI Method

%British Method
if method==2
fprintf('\n.......British Method for Mix Design.......\n')

% Step 1: Selection of target water/cement ratio
% Required data: Characteristic strength, fc or fmin: known or given; Standard deviation, s; Himsworth constant, k: depends on % defectives
% Output: w/c ratio
fprintf('\n𝐒𝐭𝐞𝐩 𝟏\n')
disp('Input characteristic compressive strength:')
disp('select unit:input 1 for MPa, 2 for Psi')
choice1=input('selection choice = ');
strength=input('Characteristic compressive strength =');
%converting to MPa unit
if choice1 == 2
    strength=strength/145;
end
% Overdesign necessary to meet strength requirements
fprintf('\n')
disp('Input defective rate (10%,5%,2.5%,1%)')
defect=input('Defective rate=');
if defect==10
        k=1.28;
elseif defect==5
        k=1.64;
elseif defect==2.5
        k=1.96;
elseif defect==1
        k=2.33;
end  
fprintf('\n')
disp('Input sample size')
sample_size=input('Sample size=');
if sample_size<20
    s=8;
else
    s=4;
end
Target_mean_strength=strength+k*s;
fprintf('\n')
disp('Choose cement type')
disp('Type 1 for Ordinary Portland Cement (OPC) or Sulphate Resisting (SRPC)')
disp('Type 2 for Rapid Hardening Cement (RHPC)')
cement_type=input('Cement type=');
disp('Type 1 for uncrushed and 2 for crushed')
    ca_type=input('Type of coarse aggregate=');
    age=input('Type age (days:3/7/28/91)=');
%using Table to calculate w/c ratio from graph    
coeff=[18 10 -2 -9;13 4 -9 -16;11 3 -8 -14; 6 -3 -15 -21];
if cement_type==1
    if ca_type==1 %uncrushed coarse aggregate
        i=1; %row index
    else  
        i=2;
    end
elseif cement_type==2
    if ca_type==1 %uncrushed coarse aggregate
        i=3;
    else 
        i=4;
    end
end
        if age==3
            j=1; %column index
        elseif age==7
             j=2;
        elseif age==28
            j=3;
        elseif age==91
             j=4;
        end
 c=coeff(i,j);
 %value according to graph
wc_graph=(-1/2.798)*log((Target_mean_strength+c)/162.052);
   
fprintf('\n')
fprintf('𝐒𝐭𝐞𝐩 𝟐\n')
slump=input('Enter slump value(mm)(maximum 180 mm)=');
agg_max=input('Maximum aggregate size(mm)(10/20/40)=');
disp('Type 1 for uncrushed and 2 for crushed')
fa_type=input('Uncrushed/Crushed(FA)=');
%values from table
water_contents=[150 180 205 225;180 205 230 250;135 160 180 195;
    170 190 210 225;115 140 160 175;155 175 190 205];
if agg_max==10
      water_contents=water_contents(1:2,:);
      elseif agg_max==20
           water_contents=water_contents(3:4,:);
          elseif agg_max==40
               water_contents=water_contents(5:6,:);
end

 if slump<=10
     j1=1; %column index
      elseif (slump>10 && slump<=30)
           j1=2;
     elseif (slump>30 && slump<=60)
          j1=3;
          elseif (slump>60 && slump<=180)
               j1=4;
 end
  
 if fa_type==1 %uncrushed fine aggregate
        fa_free_water_content=water_contents(1,j1);
            elseif fa_type==2
          fa_free_water_content=water_contents(2,j1);
 end
 %both aggregates are of same type
  if fa_type==ca_type
      free_water_content=fa_free_water_content;
  elseif fa_type~=ca_type %aggregates are of different type
  if ca_type==1
      ca_free_water_content=water_contents(1,j1);
            elseif ca_type==2
     ca_free_water_content=water_contents(2,j1);
  end
  free_water_content=(2/3)*fa_free_water_content+(1/3)*ca_free_water_content;
  end
t1=table(free_water_content,'VariableNames',{'Amount in kg/m^3'},'RowNames',{'Free Water Content'});
disp(t1)

% Step 3: Determination of cement content
% Required data: w/c ratio: from Step 1 and Free-water content: from Step 2
% Output: Cement content in kg/m^3

fprintf('𝐒𝐭𝐞𝐩 𝟑\n')
cement_content1=free_water_content/wc_graph;
fprintf('\nType 1250 for maximum allowable cement content,if not given.\n')
max_cement=input('Maximum allowable cement content (kg/m^3)=');
if cement_content1<=max_cement
    cement_content=cement_content1;
else 
    cement_content=max_cement;
end
wc1=free_water_content/cement_content;
fprintf('\nType 0.9 for maximum w/c ratio,if not given.\n')
max_wc=input('Maximum allowable free-water/cement ratio=');
if wc1<=max_wc
    wc=wc1;
t2=table([wc,cement_content]','VariableNames',{'Ratio/Amount'},'RowNames',{'Water-Cement Ratio','Cement Content (in kgm^3)'});
disp(t2)
else 
    cement_content=free_water_content/max_wc;
    if cement_content<=max_cement
 t3=table([max_wc,cement_content]','VariableNames',{'Amount'},'RowNames',{'Water-Cement Ratio','Cement Content (in kgm^3)'});
 disp(t3)
    else 
        disp('Your data are not logical.')
    end
end
% Step 4: Determination of total aggregate content
% Required data: 1) Relative density of combined aggregate in SSD condition: known, given or assumed.
% 2) Free-water content: from Step 2
% 3) Cement content: from Step 3
% Output:  Output: Total aggregate content in kg/m^3 (SSD condition)

fprintf('𝐒𝐭𝐞𝐩 𝟒\n')
relative_density=2.4:0.1:2.9;
wet_density1=[2309.434 2390.566 2476.2264 2561.5094 2647.1698 2727.9245];
wet_density2=[2161.7647 2225.8824 2276.4706 2329.4118 2390 2446.4706];
%The values of above matrices have been measured directly from the graph,
%using a ruler. Since no equations were available, these points from
%the graph were needed to make equations. However, since these measurements
%have been taken depending on vision and assumption, the values may not be
%100% correct. But the deviance is negligible for trial mix designs.

disp('Is relative density of combined aggregate given in the question?')
disp('Type 1 for yes, type 2 for no.')
yn=input('Yes/No?=');
if yn==1
    Rdcom=input('Relative density of combined aggregate=');
elseif yn==2
    if fa_type~=ca_type
        Rdcom=2.65;
    elseif fa_type==ca_type
        if fa_type==1
            Rdcom=2.6; %assumed for uncrushed aggregate
        elseif fa_type==2
            Rdcom=2.7; %assumed for crushed aggregate
        end
    end
end
wet_density3=interp1(relative_density,wet_density1,Rdcom,'linear');
wet_density4=interp1(relative_density,wet_density2,Rdcom,'linear');
wet_density=(wet_density3-wet_density4)*((100-free_water_content)/160)+wet_density3;
total_agg_content=wet_density-free_water_content-cement_content;

t4=table([wet_density,total_agg_content]','VariableNames',{'Amount in kg/m^3'},'RowNames',{'Weight of Concrete','Total Aggregate Content'});
disp(t4)

% Step 5: Determination of fine and coarse aggregate content
% Required data:
% i) Gradation of fine aggregate: known or given
% ii) Maximum size of aggregate: known or given
% iii) Slump (mm) or Vee-Bee (sec): known or given
% iv) w/c ratio: from Step 1
% Output:
% Fine aggregate content in kg/m3 (SSD condition)
% Coarse aggregate content in kg/m3 (SSD condition)
fprintf('𝐒𝐭𝐞𝐩 𝟓\n')
pass=[15 40 60 80 100];
fprintf('\n')
pass_fa=input('% of FA passing through 600µ sieve=');
if agg_max==10
    if slump<=10
        p1=[48.481 37.0886 32.7848 26.2025 22.5316];
        p2=[67.3418 54.0506 43.1646 36.3291 30.7595];
  %The values of p1 and p2 have been measured directly from the graph,
 %using a ruler. Since no equations were available, these points from
%the graph were needed to make equations. However, since these measurements
%have been taken depending on vision and assumption, the values may not be
%100% correct. But the deviance is negligible for trial mix designs.
    elseif slump>10 && slump<=30
        p1=[50 38.7341 32.7848 28.2278 23.5443];
        p2=[66.3291 53.7974 43.1646 35.6962 30.6329];
    elseif slump>30 && slump<=60
        p1=[54.9367 42.0886 36.3291 30 25.1899];
        p2=[70 55.5696 45.6962 38.481 33.2911];
    elseif slump>60 && slump<=180
        p1=[60.886 48.2278 40 32.9114 28.7342];
        p2=[77.5949 62.0253 50.2532 41.519 37.3418];
    end
elseif agg_max==20
    if slump<=10
        p1=[34.6835 26.5823 22.5316 19.2405 16.2025];
        p2=[53.6709 43.1646 35.6962 28.9873 24.9367];
    elseif slump>10 && slump<=30
        p1=[37.4684 28.9873 24.0506 20 17.8481];
        p2=[53.6709 42.7848 35.3165 30 25.3165];
    elseif slump>30 && slump<=60
        p1=[41.2658 32.0253 27.5949 22.9114 20];
        p2=[57.8481 45.6962 37.7215 31.2658 26.962];
    elseif slump>60 && slump<=180
        p1=[47.7215 38.3544 30.6329 25.8228 22.6582];
        p2=[64.4304 51.2658 42.5316 34.4304 30.8861];
    end
elseif agg_max==40
    if slump<=10
        p1=[28.0952 21.4286 18.0952 15.3571 12.619];
        p2=[46.7857 38.2143 30.2381 25.2381 21.1905];
    elseif slump>10 && slump<=30
        p1=[29.7619 23.5714 19.4643 16.5476 14.7619];
        p2=[46.1905 37.381 29.881 24.7619 21.4286]; 
    elseif slump>30 && slump<=60
        p1=[34.1667 28.4524 23.2143 19.7619 16.4881];
        p2=[50.7143 40 32.619 26.7857 23.3333];
    elseif slump>60 && slump<=180
        p1=[40.2381 32.381 26.1905 22.619 19.6429];
        p2=[57.5 45.7143 37.1429 31.3095 26.9048];
    end
end
pc1=interp1(pass,p1,pass_fa,'linear');
pc2=interp1(pass,p2,pass_fa,'linear');
   if wc<=max_wc
     percent_fa=((wc-0.8)/0.6)*(pc2-pc1)+pc2;
    else
     percent_fa=((max_wc-0.8)/0.6)*(pc2-pc1)+pc2;
   end

fine_agg_content=percent_fa*total_agg_content/100;
coarse_agg_content=total_agg_content-fine_agg_content;
t5=table([fine_agg_content,coarse_agg_content]','VariableNames',{'Amount in kg/m^3'},'RowNames',{'Fine Aggregate Content','Coarse Aggregate Content'});
disp(t5)
cement=cement_content;
end % end of British Method

%summary: For 1 cubic meter of compacted fresh concrete
densityfinal=cement+free_water_content+fine_agg_content+coarse_agg_content;
cement_bags=ceil(cement/50);
fprintf('\n')
disp('Mix Design Results: For 1 cubic meter of Compacted Fresh Concrete')
ve={'Amounts', 'Unit'};
row={'Cement','Water','Fine Aggregate','Coarse Aggregate','Density of Concrete'};
var1=[cement_bags,free_water_content,fine_agg_content,coarse_agg_content,densityfinal]';
var2=(["bags",'kg','kg','kg','kg/m^3'])';
t6=table(var1,var2,'VariableNames',ve,'RowNames',row);
disp(t6)
fprintf('Mix Ratio (by Weight)= 1:%.2f :%.2f \n',fine_agg_content/cement,coarse_agg_content/cement)

%pie chart
labels={'Cement','Water','Fine Aggregate','Coarse Aggregate'};
X=[cement,free_water_content,fine_agg_content,coarse_agg_content];
explode = [0 1 1 0];
figure
pie(X,explode)
legend(labels,'location','southeastoutside')
title('Pie Chart for 1 m^3 of Concrete')

%cost estimation
fprintf('\nTo Calculate Cost of Conrete press 1\n')
Choice10=input('=');
if Choice10 == 1
cement_cost=input('Per Bag Cement cost (in BDT)=');
fa_cost=input('Per m^3 Fine Aggregate cost (in BDT)=');
ca_cost=input('Per m^3 Coarse Aggregate cost (in BDT)=');
fprintf('\n')
disp('Cost Estimation: For 1 cubic meter of fresh concrete')
ve_c={'Amounts', 'Per unit cost','Total cost'};
row_c={'Cement Bag','Fine Aggregate','Coarse Aggregate'};
var_c1=[cement_bags,fine_agg_content,coarse_agg_content]';
var_c2=[cement_cost,fa_cost,ca_cost]';
var_c3=var_c1.*var_c2;
t7=table(var_c1,var_c2,var_c3,'VariableNames',ve_c,'RowNames',row_c);
disp(t7)
fprintf('Total cost of concrete = %.2f Tk.\n',sum(var_c3))
end

%trial mix
fprintf('\n')
 disp(['Do You Want to Calculate Amount for Trial Mix? ' ...
     'press 1 ,else press 2'])
 choice7=input(' =');
 if choice7==2
     disp('end of session')
 end
 
%Step 10:Adjustment for trial batch
if choice7==1
disp('select number of specimen to be casted')
n=input('no of specimens=');
fprintf('\n')
disp('select type of specimen to be casted')
disp('select 1 for cylinder,2 for rectangular,3 for square block')
choice8=input('specimen type=');
fprintf('\n')
disp('unit of dimensions:1 for meter,2 for feet')
choice9=input('unit choice=');
fprintf('\n')
height=input('height=');

if choice8==1
    radius=input('radius=');
    trial_volm=1.5*n*height*pi*radius^2;
elseif choice8==2 
    length1=input('length=');
   width=input('width=');
    trial_volm=1.5*n*height*width*length1;
elseif choice8==3
   trial_volm=1.5*n*height^3; 
end
if choice9==2
    trial_volm=trial_volm *(.3048)^3;%converting to m^3
end
fprintf('\nVolume of Trial Mix = %f m^3 \n',trial_volm)

%mass for trial volume
fprintf('\nMix Design Results: For trial mix\n')
ve1={'Amounts for 1 m^3','Amounts for Trial Mix', 'Unit'};
var3=trial_volm.*var1;
var3(1)=ceil(var3(1));
t8=table(var1,var3,var2,'VariableNames',ve1,'RowNames',row);
disp(t8)
end
 %sieve analysis
disp(['press 1 for sieve ananlysis of Fine Aggregate,' ...
    '2  for Coarse Aggregate'])
choice11=input('=');
     %sieve ananlysis of Fine Aggregate
   sieve_no=[4 8 16 30 50 100 200]';
sieve_size=[4.75 2.36 1.18 .6 .3 .15 .075]';
 
if choice11==2 %sieve ananlysis of Coarse Aggregate
 sieve_size=[25 19 12.5 9.5 4.75 2.36 ]';
end
j=length(sieve_size);
mass=zeros(j,1);
for i=1:j
    fprintf('mass retained for sieve size %.2f mm',sieve_size(i))
    mass(i)=input('=');
end
total=sum(mass);
individual_retained=zeros(j,1);
for i=1:j
individual_retained(i)=round((mass(i)*100)/total);
end
cumulative_retained=cumsum(individual_retained);%cumulative sum
finer=100-cumulative_retained;
if choice11==1
FM1=sum(cumulative_retained(1:j-1))/100;
%table create
ve2={'Sieve No.','Sieve Size(mm)','Mass Retained (g)','Individiual Retained(%)','Cumulative Retained(%)','% Finer'};
t5=table(sieve_no,sieve_size,mass,individual_retained,cumulative_retained,finer,'VariableNames',ve2);
disp(t5)
fprintf('Fineness modulus is %.2f \n',FM1)

%semilog graph generating
figure
semilogx(sieve_size',finer','-o',MarkerFaceColor='r')
grid on
title('Gradation Curve','FontSize',15)
xlabel('Sieve opening (mm)'),ylabel('%Finer')
legend('for fine aggregate',Location='southeast')
end

if choice11==2
    FM2=(cumulative_retained(2)+sum(cumulative_retained(4:j))+400)/100;
%table create
ve2={'Sieve Size(mm)','Mass Retained (g)','Individiual Retained(%)','Cumulative Retained(%)','% Finer'};
t5=table(sieve_size,mass,individual_retained,cumulative_retained,finer,'VariableNames',ve2);
disp(t5)
fprintf('Fineness modulus is %.2f \n',FM2)

figure
semilogx(sieve_size',finer','-o',MarkerFaceColor='r')
grid on
title('Gradation Curve','FontSize',15)
xlabel('Sieve opening (mm)'),ylabel('%Finer')
legend('for coarse aggregate',Location='northwest')
end
 %Coefficient of Uniformity, 𝐶𝑢 and Coefficient of Curvature (𝐶𝑐 𝑜𝑟 𝐶z)
 %Cu=D60/D10, Cz=(D30)^2/D10*D60,
D60=interp1(finer,sieve_size,60,"linear");
D10=interp1(finer,sieve_size,10,"linear");
D30=interp1(finer,sieve_size,30,"linear");
Cu=D60/D10;
Cz=(D30)^2/(D10*D60);
fprintf('Coefficient of Uniformity,Cu = %.2f \n',Cu)
fprintf('Coefficient of Curvature,Cz = %.2f \n',Cz)

fprintf(['\n End of Session\n' ...
    '.........Thank You.........\n'])
