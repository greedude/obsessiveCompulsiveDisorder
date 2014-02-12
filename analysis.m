
total(1,:)= data_analysis('zbz');
total(2,:)= data_analysis('kongw');
total(3,:)= data_analysis('yang xie');


total(4,:)= data_analysis('wang_yue_20140106');
total(5,:)= data_analysis('subject2');
total(6,:)= data_analysis('subject3');
total(7,:)= data_analysis('subject4');
total(8,:)= data_analysis('niwenweiajou-se');

sem1 = std(total(1:3,:))/sqrt(length(total(:,1)));0

mean_v1 = mean(total(1:3,:));

sem2 = std(total(4:8,:))/sqrt(length(total(:,1)));
mean_v2 = mean(total(4:8,:));

h1=errorbar([0.5 1.5 2.5 3.5 4.5 ],mean_v1,sem1);
hold;
h2=errorbar([0.5 1.5 2.5 3.5 4.5 ],mean_v2,sem2);
h = line([0 5],[0 0]);
set(h,'Color','k');
set(h1,'Color','k','Marker','^');
set(h2,'Color','k','Marker','o');
set(gca, 'XTick',0:5,'YTick',[-12 -8 -4 0 4 8 12])
axis([0 5 -20 20]);