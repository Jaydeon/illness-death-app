%  Use these to initialize the data set if it's not already initialized
%  For testing/coding purposes, don't use these because they take hella long
%  structproj = webread("https://data.cdc.gov/api/views/mr8w-325u/rows.csv?accessType=DOWNLOAD");
%  structproj = table2struct(structproj); 

clearvars -except structproj;
tic; %Times the elapsed time for the code
fid = fopen('project.dat','w');
clf('reset'); %Resets figure window to be used again
fprintf("Grabbing data . . .\n"); %Lets the user know that data is being generated
num = 1; %Initializes variable used for indexing into the struct that isolates data
minRat = '';
selectedYear = 1962:1965; %Customizable: years that are selected by user interface
selectedCity = {"Boston, MA"};%CitiesValueChanged; %Customizable: cities that are selected by user interface
statelessCity(length(selectedCity)) = selectedCity{end}; %Preallocates a vector for cities with states
for i = 1:length(selectedCity) %Removes the state designations
    statelessCity(i) = strtok(selectedCity{i},',');
end 
selectedData(length(structproj)) = structproj(1); %Preallocates a struct with isolated data 


for z = 1:length(statelessCity) %Selects data points that match with each city selected
    for j = 1:length(selectedYear) %Selects data points that match with each year selected
        for i = 1:length(structproj)
            if (structproj(i).Year == selectedYear(j) && structproj(i).City == statelessCity(z)) 
                selectedData(num) = structproj(i); 
                num = num+1; %Variable for next index in selectedData struct
            end

        end
    end

    %Preallocates variables that will add a running sum of deaths for total and for illnesses
    totDeaths = 1:length(selectedYear); 
    illDeaths = 1:length(selectedYear); 


    for i = 1:length(selectedData) %Adds all of the total deaths in one year
        for j = 1:length(selectedYear)
            if selectedData(i).Year == selectedYear(j)
                if isnan(selectedData(i).AllDeaths)
                    selectedData(i).AllDeaths = 0;
                end
                totDeaths(j) = totDeaths(j) + selectedData(i).AllDeaths;
            end
        end
    end

    for i = 1:length(selectedData) %Adds all of the illness deaths in one year
        for j = 1:length(selectedYear)
            if selectedData(i).Year == selectedYear(j)
                if isnan(selectedData(i).PneumoniaAndInfluenzaDeaths)
                    selectedData(i).PneumoniaAndInfluenzaDeaths = 0;
                end
                illDeaths(j) = illDeaths(j) + selectedData(i).PneumoniaAndInfluenzaDeaths;
            end
        end
    end

    Ratio = 1:length(selectedYear); %Preallocates a variable for the ratio of illness deaths to total deaths

    totRat = 0;
    for i = 1:length(selectedYear) %Creates a vector with the ratios of illness deaths to total deaths for each year
        Ratio(i) = illDeaths(i)/totDeaths(i);
        totRat = Ratio(i);
    end
    avgRat = totRat/length(selectedYear);
    if isempty(minRat)
        minRat = avgRat;
    elseif avgRat < minRat
        minRat = avgRat;
        minCity = selectedCity(z);
    end 
    fprintf(fid,"The average ratio for %s is %.2f.\n",selectedCity{z},avgRat);
   
        
    fprintf("Plotting data for %s . . .\n",selectedCity{z});
    plot(selectedYear,Ratio); %Plots the selected years against the ratio of deaths
    hold on; %Holds graph so data of cities can be compared
    if length(selectedYear) < 10
        xticks(selectedYear); %Sets x-axis to display years as integers (if there's greater than 10 elements, it does this automatically)
    end
    clear selectedData illDeaths totDeaths Ratio selectedCityNoState %Frees these variables to be used again
end
fprintf(fid,"\nThe minimum average ratio is %.2f at %s",minRat,selectedCity{z});
fclose('all');
legend(selectedCity) %Makes legend for each city
timeElapsed = toc; %End stopwatch
fprintf("Done! Finished in %.1f seconds.\n",timeElapsed);




