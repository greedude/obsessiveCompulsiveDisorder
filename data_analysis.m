function [net_scores] = data_analysis(data_name)
total = 0;
net_scores = [0 0 0 0 0];


    datafilename = strcat('data\',data_name,'.dat');
    DATA = dlmread(datafilename,' ');
    for i=1:5
        for j =1:20
            index = 20*(i-1)+j;
            deck = DATA(index,2);
            switch deck
                case 1
                    score = -1;
                case 2
                    score = -1;
                case 3
                    score = 1;
                case 4
                    score = 1;
             end
            total = total + score;
        end
    net_scores(i) = total;
    total = 0;
    end
    




h1=plot([0.5 1.5 2.5 3.5 4.5],net_scores,'k');
h = line([0 5],[0 0]);
set(h,'Color','k');
set(h1,'Marker','O');
set(gca, 'XTick',1:5,'XTickLabel',{'1-20' '21-40' '41-60' '61-80' '81-100'})
axis([0 5 -20 20]);
saveas(h,data_name,'png');
end