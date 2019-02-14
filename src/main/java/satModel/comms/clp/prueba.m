clear all
%GS_name: Ground station names ('Wallops', 'WhiteSands', 'McMurdo','Solna')
paramscomms.ngs=1;
paramscomms.GS_name={'Wallops','WhiteSands','Solna'};
[num,txt,rawTime]=xlsread('../xls/NEN_contacts_duration.xlsx',2,'B6:H85');
[num1,txt1,rawDL]=xlsread('../xls/NEN_contacts_duration.xlsx',2,'J6:Z9');
[num2,txt2,rawUL]=xlsread('../xls/NEN_contacts_duration.xlsx',2,'J14:T17');
paramscomms.rawTime=rawTime;
paramscomms.rawDL=rawDL;
paramscomms.rawUL=rawUL;