load 1_7_16_data_sp11_sp_12.mat
load 1_7_16_data_sp13_sp14.mat
load 1_7_16_data_sp15_sp16.mat
load 1_7_16_data_sp1_sp2.mat
load 1_7_16_data_sp3_sp4.mat
load 1_7_16_data_sp5_sp6.mat
load 1_7_16_data_sp7_sp8.mat
load 1_7_16_data_sp9_sp_10.mat

dataset_proceed = zeros(320, 33075);
dataset_innovate = zeros(320, 33075);

for i=1:20
    audio1(:,:) = final_audio_sub3(1,i,:);
    audio1= audio1';
    dataset_proceed((3-1)*20+i,:) = audio1(1,:);
    audio2(:,:) = final_audio_sub3(2,i,:);
    audio2= audio2';
    dataset_innovate((3-1)*20+i,:) = audio2(1,:);
    clear audio1;
    clear audio2;
end
