cityData= {'Lagos|ng','Jakarta|id','Bangkok|th','Nairobi|ke','Rio de Janeiro|br','Accra|gh','Longyearbyen|no','Khartoum|sd'};
for i = 1:length(cityData)
    [cityItself(i),country(i)] = strtok(cityData(i),'|');
    country(i) = erase(country(i),'|');
end
for i = 1:length(cityItself)
    api{i} = strcat('http://api.openweathermap.org/data/2.5/forecast?q=',cityItself{i},',',country{i},'&APPID=70e9f383955e7372c06948520cd38387');
end
for i = 1:length(api)
    city(i) = webread(api{i});
    fprintf('RETREIVING WEATHER DATA FOR %s...\n',city(i).city.name)
end
for j = 1:length(cityItself) 
    for i = 1:length(city(j).list)
        if iscell(city(j).list)
            mintemps.cities(j).temp(i) = city(j).list{i,1}.main.temp_min;
        else
            mintemps.cities(j).temp(i) = city(j).list(i).main.temp_min;
        end
    end
    mintemp(j) = (((min(mintemps.cities(j).temp) - 273.15) * 9 / 5) + 32);
end
plot(mintemp,'k.');
xticklabels(cityItself);
xlabel('Cities')
ylabel('Temperature (F)');
title('Min Temperatures Over 5 Days')
for j = 1:length(cityItself) 
    for i = 1:length(city(j).list)
        if iscell(city(j).list)
            temps.cities(j).temp(i) = city(j).list{i,1}.main.temp;
        else
            temps.cities(j).temp(i) = city(j).list(i).main.temp;
        end
    end
end
figure(2)
hold on
for i = 1:length(cityItself)
    temps.cities(i).temp = ((((temps.cities(i).temp) - 273.15) * 9 / 5) + 32);
    plot(1:3:(length(temps.cities(1).temp) * 3),   temps.cities(i).temp);
end
xticks(0:12:((length(temps.cities(1).temp) * 3) + 12));
xticklabels(0:12:((length(temps.cities(1).temp) * 3) + 12));
title('Hourly Temperatures Over 5 Days');
xlabel('Time (hrs)');
ylabel('Temperature (F)');
legend(cityItself);