function x=datefeatures(datetimes,datenums, logic_vector)
%
%% Docs
% return all sorts of features based on date string datetime
%logic_vector is a binary vector requesting features 
% datenums is a logical bin if the feeded data is datenums
% x is matrix
% x=[year season month yearday monthday weekday working_day hour_of_day...
%     working_hour rush_hour daylight_hour]
%
%% Extract data
% Create a column of datetime strings
if datenums==0
dt_strings = datetimes;

% Convert the datetime strings to a datetime array
dt_array = datetime(dt_strings, 'InputFormat', 'yyyy-MM-dd HH:mm:ss');
else
dt_array = datetime(datetimes, 'ConvertFrom', 'datenum');

end
%% Year & Season features

% Determine year
years = year(dt_array);

% Determine vernal equinox date for year
vernal_equinox = datetime(years, 3, fix(20.69115 + 0.242194 * (years - 1980)), 7, 37, 0);

% Determine summer solstice date for year
summer_solstice = datetime(years, 6, fix(20.31003 + 0.242194 * (years - 1980)), 23, 32, 0);

% Determine autumnal equinox date for year
autumnal_equinox = datetime(years, 9, fix(23.09056 + 0.242194 * (years - 1980)), 13, 31, 0);

% Determine winter solstice date for year
winter_solstice = datetime(years, 12, fix(20.21852 + 0.242194 * (years - 1980)), 18, 23, 0);

getSeason = @(dt_array) (dt_array >= vernal_equinox & dt_array < summer_solstice) + ...
                  2*(dt_array >= summer_solstice & dt_array < autumnal_equinox) + ...
                  3*(dt_array >= autumnal_equinox & dt_array < winter_solstice) + ...
                  4*(dt_array < vernal_equinox | dt_array >= winter_solstice);
season = arrayfun(getSeason, dt_array, 'UniformOutput', false);
season = cellfun(@(x) x(1), season);

%% Month & Day features

% Extract the month
months = month(dt_array, 'monthofyear');

% Extract the yearday
yearday = day(dt_array, 'dayofyear');

% Extract the monthday
monthday = day(dt_array, 'dayofmonth');

% Extract the weekday
weekday = day(dt_array, 'dayofweek');

% Check if it's a working day (Monday to Friday)
working_day = ~isweekend(dt_array);

%% Hour features

% Extract hour of day (0-23)
hour_of_day = hour(dt_array);

% Determine if it's a working hour (9am-5pm)
working_hour = (hour_of_day >= 9) & (hour_of_day <= 17);

% Determine if it's a rush hour (7am-9am or 4pm-6pm)
rush_hour = ((hour_of_day >= 7) & (hour_of_day <= 9)) | ((hour_of_day >= 16) & (hour_of_day <= 18));

% Determine sunrise and sunset times for Sofia on the date of the datetime object
[sunrises, sunset] = sunrise(42.6975, 23.3241, 550,[],dt_array);
sunrises = datetime(sunrises, 'ConvertFrom', 'datenum');
sunset = datetime(sunset, 'ConvertFrom', 'datenum');

% Determine if it's a daylight hour
daylight_hour = ~((dt_array <= sunrises) | (dt_array >= sunset));

%% Structure data

x=[years season months yearday monthday weekday working_day hour_of_day...
    working_hour rush_hour daylight_hour];
logic_vector=logical(logic_vector);

x=x(:,logic_vector);


end