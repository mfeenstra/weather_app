
# Apple Exercise

-----

Greetings,

I would have liked to put the finishing touches on this documention.  But in the interest of time, I am sending
it over with full functionality and including the notes I've drafted along the way.

Please have a look at the screenshots provided by the hyperlinks below:

[OpenWeatherMap API](ss/api_openweathermap_current_weather.png)

[OpenWeatherMap API for 5 day / 3 hour forecast](ss/api_openweathermap_forecast.png)

[Example 1 from forecast insert](ss/forecast_insert1.png)

[Example 2 from forecast insert](ss/forecast_insert2.png)

[Example 1 from Current weather data insert](ss/current_weather_insert.png)

[Model (2) Schema](ss/model_schema.png)

[Forecast data table](ss/forecast_data_table.png)

[Locations model main index](ss/locations_main_index.png)

[New Locations Creation](ss/new_locale_creation.png)

[Show Model Render](ss/show_model_render.png)

[Forecast Table](ss/forecast_table.png)

[Show Location Model](ss/show_location.png)

[Locations Model](ss/model_locations.png)

----

## Directions:

### Unit Tests!!


### Detailed Comments/Docuemntation wihin the code + README.md


### Include _*Decomposition*_ of the Objects in the Documentation


### Design patterns where Applicable


### Scalability Considerations where Applicable


### Naming Conventions as if it were enterprise-scale


### Encapsulation (do not have 1 method doing 55 things)


### Code Re-Use (don't over engineer or under engineer solution)


### Best pracices from the industry

-----

## Specification:

### Weather Application

1.  Accept address as input

    - Form w/ Submit

2.  One Forecast per given Address, includes (at minimum):

    - Current Temperature

    - Bonus points:

    - High and Low Temperatures

    - Extended Forecast

3.  Display the Forecast details to the user

4.  Cache the Forecast for 30 minutes for all subsequent requests by zip code.

    - Display indicator for result if it came from the cache

-----

## Database Tables and Schema

-  The idea is to have an inner join linkage of two tables.  Having foreign keys and constraints from one table to the other, for efficiency.

-  postgresDB version 14

```sql
weather_app_development=# \dt
               List of relations
 Schema |         Name         | Type  | Owner 
--------+----------------------+-------+-------
 public | ar_internal_metadata | table | matt
 public | locations            | table | matt
 public | metrics              | table | matt
 public | schema_migrations    | table | matt
(4 rows)

weather_app_development=# \dt locations;
         List of relations
 Schema |   Name    | Type  | Owner 
--------+-----------+-------+-------
 public | locations | table | matt
(1 row)

weather_app_development=# \dt metrics;
        List of relations
 Schema |  Name   | Type  | Owner 
--------+---------+-------+-------
 public | metrics | table | matt
(1 row)

weather_app_development=# 
```


##  Design

- Name: Forecast App (forecast_app)

- Data Models:

1.  Address

    - Unique ID

    - Street

    - City

    - Zip Code

2.  Forecast

    - Unique ID

    - Address Unique ID

    - Current Temperature

    - Day of Year
    
3.  Forecast Extended

----------

## models descriptions

1.  (table) Location(s)

    - has a unique index `id`, same as `location_id` below, and index as `zipcode`, can have__many `metric`(s)

2.  (table) Metric

    - one per period
    - has a id
    - one per day

### Create `location` model with:

```sh
rails g model location zipcode:string:index city:string country:string{3} street:string lat:decimal long:decimal
or use scaffold
rails g scaffold Location zipcode:string:index street:string city:string country_code:string lat:decimal long:decimal
```

```sh
location
--------
id
zipcode
street
city
country
lat
long
```

Generate Scaffold:

```ruby
      invoke  active_record
      create    db/migrate/20221026074025_create_locations.rb
      create    app/models/location.rb
      invoke    test_unit
      create      test/models/location_test.rb
      create      test/fixtures/locations.yml
      invoke  resource_route
       route    resources :locations
      invoke  scaffold_controller
      create    app/controllers/locations_controller.rb
      invoke    erb
      create      app/views/locations
      create      app/views/locations/index.html.erb
      create      app/views/locations/edit.html.erb
      create      app/views/locations/show.html.erb
      create      app/views/locations/new.html.erb
      create      app/views/locations/_form.html.erb
      create      app/views/locations/_location.html.erb
      invoke    resource_route
      invoke    test_unit
      create      test/controllers/locations_controller_test.rb
      create      test/system/locations_test.rb
      invoke    helper
      create      app/helpers/locations_helper.rb
      invoke      test_unit
      invoke    jbuilder
      create      app/views/locations/index.json.jbuilder
      create      app/views/locations/show.json.jbuilder
      create      app/views/locations/_location.json.jbuilder

```

```sh
rails g scaffold metric location_id:integer:index zipcode:string:index temp:decimal min:decimal max:decimal day:integer

      invoke  active_record
      create    db/migrate/20221026074226_create_metrics.rb
      create    app/models/metric.rb
      invoke    test_unit
      create      test/models/metric_test.rb
      create      test/fixtures/metrics.yml
      invoke  resource_route
       route    resources :metrics
      invoke  scaffold_controller
      create    app/controllers/metrics_controller.rb
      invoke    erb
      create      app/views/metrics
      create      app/views/metrics/index.html.erb
      create      app/views/metrics/edit.html.erb
      create      app/views/metrics/show.html.erb
      create      app/views/metrics/new.html.erb
      create      app/views/metrics/_form.html.erb
      create      app/views/metrics/_metric.html.erb
      invoke    resource_route
      invoke    test_unit
      create      test/controllers/metrics_controller_test.rb
      create      test/system/metrics_test.rb
      invoke    helper
      create      app/helpers/metrics_helper.rb
      invoke      test_unit
      invoke    jbuilder
      create      app/views/metrics/index.json.jbuilder
      create      app/views/metrics/show.json.jbuilder
      create      app/views/metrics/_metric.json.jbuilder

```

### Create `metric` model with:

rails g model metric location_id:integer:index zipcode:string:index temp:decimal min:decimal max:decimal period:integer cached_at:datetime

```sh
metric
------
id
location_id
zipcode
temp
min
max
cached_at
period
```

### Seed data:

- `<app_root>/db/seeds.rb`

### Setup DB:

- `export RAILS_ENV=development && rails db:setup && rails db:migrate`



### Test models with:

- `rails db:seed` provides significant data model validation

- from the rails app's root folder

- run: `rails test test/models/location_test.rb`

- run: `rails test test/models/metric_test.rb`



3.  (array) Metric

    - individual days correspond with the index of an Array of metric

    - today is d=0, and each subsequent day is d+1 index of the Array

---------

### Controllers

1. Location

- create__new

  To take form/submit data and create a new model

- download__weather (today and future)

  To query the API and populate the database

- weather__now + weather__forecast

  To get weather for today and into the future


Run with:

```ruby
rails g controller Location create_new download_weather weather
```

```ruby
      create  app/controllers/location_controller.rb
       route  get 'location/create_new'
              get 'location/download_weather'
              get 'location/weather'
      invoke  erb
      create    app/views/location
      create    app/views/location/create_new.html.erb
      create    app/views/location/download_weather.html.erb
      create    app/views/location/weather.html.erb
      invoke  test_unit
      create    test/controllers/location_controller_test.rb
      invoke  helper
      create    app/helpers/location_helper.rb
      invoke    test_unit
```

2. Metric

- by_zipcode

Run with:
```ruby
rails g controller Metric by_zipcode                           
```

```ruby
     create  app/controllers/metric_controller.rb
       route  get 'metric/by_zipcode'
      invoke  erb
      create    app/views/metric
      create    app/views/metric/by_zipcode.html.erb
      invoke  test_unit
      create    test/controllers/metric_controller_test.rb
      invoke  helper
      create    app/helpers/metric_helper.rb
      invoke    test_unit
```

### Test Data (fixtures)

- test/locations_only.rb

- test/locations_current+forecasts.rb

```shell
matt@Airbook:0:~/Apple/weather_app/test$ locations_current+forecasts.rb 
xhttp [200]
D, [2022-10-27T18:14:07.601985 #68090] DEBUG -- : ForecastByZip(95660, us)
http [200]
.xhttp [200]
D, [2022-10-27T18:14:08.338190 #68090] DEBUG -- : ForecastByZip(E1 7AW, gb)
http [200]
.xhttp [200]
D, [2022-10-27T18:14:08.972819 #68090] DEBUG -- : ForecastByZip(E1 7BH, gb)
http [200]
.xhttp [200]
D, [2022-10-27T18:14:09.579569 #68090] DEBUG -- : ForecastByZip(90210, us)
http [200]
.xhttp [404]
E, [2022-10-27T18:14:10.228750 #68090] ERROR -- : bad api result: {"cod"=>"404", "message"=>"city not found"}
D, [2022-10-27T18:14:10.234160 #68090] DEBUG -- : ForecastByZip(z3dz d3d, ZED)
http [404]
E, [2022-10-27T18:14:10.421595 #68090] ERROR -- : could not get the forecast! (z3dz d3d, ZED)
.xhttp [200]
D, [2022-10-27T18:14:10.633741 #68090] DEBUG -- : ForecastByZip(92260, us)
http [200]
.xhttp [200]
D, [2022-10-27T18:14:11.248021 #68090] DEBUG -- : ForecastByZip(90001, us)
http [200]
.xhttp [200]
D, [2022-10-27T18:14:11.854080 #68090] DEBUG -- : ForecastByZip(T1L 1A7, ca)
http [404]
E, [2022-10-27T18:14:12.050019 #68090] ERROR -- : could not get the forecast! (T1L 1A7, ca)
```


```sql
weather_app_development=# select * from locations;
 id | zipcode  |      street       |     city      | country_code | lat | long |         created_at         |         updated_at         
----+----------+-------------------+---------------+--------------+-----+------+----------------------------+----------------------------
 25 | 95660    | 888 sesame street | sacramento    | us           |     |      | 2022-10-28 01:14:07.268945 | 2022-10-28 01:14:07.268945
 26 | E1 7AW   | 12345 port st     | london        | gb           |     |      | 2022-10-28 01:14:08.076881 | 2022-10-28 01:14:08.076881
 27 | E1 7BH   | 999 imperial pkwy | london        | gb           |     |      | 2022-10-28 01:14:08.775535 | 2022-10-28 01:14:08.775535
 28 | 90210    | 983 friends rd    | beverly hills | us           |     |      | 2022-10-28 01:14:09.395091 | 2022-10-28 01:14:09.395091
 29 | z3dz d3d | XYZ garbage st.   | bad_town      | ZED          | 0.0 |  1.0 | 2022-10-28 01:14:09.968365 | 2022-10-28 01:14:09.968365
 30 | 92260    | 777 el paseo      | palm desert   | us           |     |      | 2022-10-28 01:14:10.431311 | 2022-10-28 01:14:10.431311
 31 | 90001    | 956 main wy       | los angeles   | us           |     |      | 2022-10-28 01:14:11.037803 | 2022-10-28 01:14:11.037803
 32 | T1L 1A7  | 567 apline rd     | banff         | ca           |     |      | 2022-10-28 01:14:11.66426  | 2022-10-28 01:14:11.66426
(8 rows)

weather_app_development=# 
```

Short Sample:

```sql
 id  | location_id | zipcode  | temp  |  min  |  max  | period |         created_at         |         updated_at         |       dt_txt        | from_cache 
-----+-------------+----------+-------+-------+-------+--------+----------------------------+----------------------------+---------------------+------------
 413 |          25 | 95660    | 68.59 | 64.06 | 71.46 |      0 | 2022-10-28 01:14:07.598073 | 2022-10-28 01:14:07.598073 | 2022-10-28 01:02:02 | 
 414 |          25 | 95660    | 65.57 | 61.14 | 65.57 |      1 | 2022-10-28 01:14:07.909905 | 2022-10-28 01:14:07.909905 | 2022-10-28 10:00:00 | 
 415 |          25 | 95660    | 60.67 | 57.11 | 60.67 |      2 | 2022-10-28 01:14:07.917806 | 2022-10-28 01:14:07.917806 | 2022-10-28 13:00:00 | 
 416 |          25 | 95660    | 54.55 | 54.55 | 54.55 |      3 | 2022-10-28 01:14:07.924126 | 2022-10-28 01:14:07.924126 | 2022-10-28 16:00:00 | 
 417 |          25 | 95660    | 52.72 | 52.72 | 52.72 |      4 | 2022-10-28 01:14:07.93148  | 2022-10-28 01:14:07.93148  | 2022-10-28 19:00:00 | 
 418 |          25 | 95660    | 52.02 | 52.02 | 52.02 |      5 | 2022-10-28 01:14:07.938836 | 2022-10-28 01:14:07.938836 | 2022-10-28 22:00:00 | 
 419 |          25 | 95660    | 63.84 | 63.84 | 63.84 |      6 | 2022-10-28 01:14:07.945276 | 2022-10-28 01:14:07.945276 | 2022-10-29 01:00:00 | 
 420 |          25 | 95660    |  69.8 |  69.8 |  69.8 |      7 | 2022-10-28 01:14:07.952413 | 2022-10-28 01:14:07.952413 | 2022-10-29 04:00:00 | 
 421 |          25 | 95660    | 68.31 | 68.31 | 68.31 |      8 | 2022-10-28 01:14:07.958813 | 2022-10-28 01:14:07.958813 | 2022-10-29 07:00:00 | 
 422 |          25 | 95660    | 62.49 | 62.49 | 62.49 |      9 | 2022-10-28 01:14:07.965864 | 2022-10-28 01:14:07.965864 | 2022-10-29 10:00:00 | 
 423 |          25 | 95660    | 57.24 | 57.24 | 57.24 |     10 | 2022-10-28 01:14:07.972706 | 2022-10-28 01:14:07.972706 | 2022-10-29 13:00:00 | 
 424 |          25 | 95660    | 54.32 | 54.32 | 54.32 |     11 | 2022-10-28 01:14:07.979717 | 2022-10-28 01:14:07.979717 | 2022-10-29 16:00:00 | 
 425 |          25 | 95660    | 51.96 | 51.96 | 51.96 |     12 | 2022-10-28 01:14:07.986827 | 2022-10-28 01:14:07.986827 | 2022-10-29 19:00:00 | 
 426 |          25 | 95660    | 51.94 | 51.94 | 51.94 |     13 | 2022-10-28 01:14:07.993377 | 2022-10-28 01:14:07.993377 | 2022-10-29 22:00:00 | 
 427 |          25 | 95660    | 63.75 | 63.75 | 63.75 |     14 | 2022-10-28 01:14:07.99857  | 2022-10-28 01:14:07.99857  | 2022-10-30 01:00:00 | 
 428 |          25 | 95660    | 72.93 | 72.93 | 72.93 |     15 | 2022-10-28 01:14:08.0039   | 2022-10-28 01:14:08.0039   | 2022-10-30 04:00:00 | 
 429 |          25 | 95660    | 73.67 | 73.67 | 73.67 |     16 | 2022-10-28 01:14:08.008963 | 2022-10-28 01:14:08.008963 | 2022-10-30 07:00:00 | 
 430 |          25 | 95660    | 63.28 | 63.28 | 63.28 |     17 | 2022-10-28 01:14:08.014134 | 2022-10-28 01:14:08.014134 | 2022-10-30 10:00:00 | 
 431 |          25 | 95660    | 59.02 | 59.02 | 59.02 |     18 | 2022-10-28 01:14:08.029451 | 2022-10-28 01:14:08.029451 | 2022-10-30 13:00:00 | 
 432 |          25 | 95660    | 56.48 | 56.48 | 56.48 |     19 | 2022-10-28 01:14:08.031923 | 2022-10-28 01:14:08.031923 | 2022-10-30 16:00:00 | 
 433 |          25 | 95660    | 53.96 | 53.96 | 53.96 |     20 | 2022-10-28 01:14:08.034332 | 2022-10-28 01:14:08.034332 | 2022-10-30 19:00:00 | 
 434 |          25 | 95660    | 52.88 | 52.88 | 52.88 |     21 | 2022-10-28 01:14:08.036451 | 2022-10-28 01:14:08.036451 | 2022-10-30 22:00:00 | 
 435 |          25 | 95660    | 65.82 | 65.82 | 65.82 |     22 | 2022-10-28 01:14:08.03852  | 2022-10-28 01:14:08.03852  | 2022-10-31 01:00:00 | 
 436 |          25 | 95660    |  74.7 |  74.7 |  74.7 |     23 | 2022-10-28 01:14:08.040491 | 2022-10-28 01:14:08.040491 | 2022-10-31 04:00:00 | 
 437 |          25 | 95660    | 75.33 | 75.33 | 75.33 |     24 | 2022-10-28 01:14:08.042494 | 2022-10-28 01:14:08.042494 | 2022-10-31 07:00:00 | 
 438 |          25 | 95660    | 64.31 | 64.31 | 64.31 |     25 | 2022-10-28 01:14:08.044542 | 2022-10-28 01:14:08.044542 | 2022-10-31 10:00:00 | 
 439 |          25 | 95660    | 59.27 | 59.27 | 59.27 |     26 | 2022-10-28 01:14:08.046591 | 2022-10-28 01:14:08.046591 | 2022-10-31 13:00:00 | 
 440 |          25 | 95660    | 56.88 | 56.88 | 56.88 |     27 | 2022-10-28 01:14:08.048656 | 2022-10-28 01:14:08.048656 | 2022-10-31 16:00:00 | 
 441 |          25 | 95660    | 54.25 | 54.25 | 54.25 |     28 | 2022-10-28 01:14:08.050637 | 2022-10-28 01:14:08.050637 | 2022-10-31 19:00:00 | 
 442 |          25 | 95660    | 53.28 | 53.28 | 53.28 |     29 | 2022-10-28 01:14:08.052614 | 2022-10-28 01:14:08.052614 | 2022-10-31 22:00:00 | 
 443 |          25 | 95660    | 66.29 | 66.29 | 66.29 |     30 | 2022-10-28 01:14:08.054557 | 2022-10-28 01:14:08.054557 | 2022-11-01 01:00:00 | 
 444 |          25 | 95660    | 72.68 | 72.68 | 72.68 |     31 | 2022-10-28 01:14:08.056387 | 2022-10-28 01:14:08.056387 | 2022-11-01 04:00:00 | 
 445 |          25 | 95660    | 71.19 | 71.19 | 71.19 |     32 | 2022-10-28 01:14:08.05836  | 2022-10-28 01:14:08.05836  | 2022-11-01 07:00:00 | 
 446 |          25 | 95660    | 64.45 | 64.45 | 64.45 |     33 | 2022-10-28 01:14:08.060288 | 2022-10-28 01:14:08.060288 | 2022-11-01 10:00:00 | 
 447 |          25 | 95660    | 60.15 | 60.15 | 60.15 |     34 | 2022-10-28 01:14:08.061971 | 2022-10-28 01:14:08.061971 | 2022-11-01 13:00:00 | 
 448 |          25 | 95660    | 55.58 | 55.58 | 55.58 |     35 | 2022-10-28 01:14:08.063509 | 2022-10-28 01:14:08.063509 | 2022-11-01 16:00:00 | 
 449 |          25 | 95660    | 52.56 | 52.56 | 52.56 |     36 | 2022-10-28 01:14:08.065428 | 2022-10-28 01:14:08.065428 | 2022-11-01 19:00:00 | 
 450 |          25 | 95660    | 53.22 | 53.22 | 53.22 |     37 | 2022-10-28 01:14:08.067349 | 2022-10-28 01:14:08.067349 | 2022-11-01 22:00:00 | 
 451 |          25 | 95660    | 57.74 | 57.74 | 57.74 |     38 | 2022-10-28 01:14:08.069254 | 2022-10-28 01:14:08.069254 | 2022-11-02 01:00:00 | 
 452 |          25 | 95660    | 58.75 | 58.75 | 58.75 |     39 | 2022-10-28 01:14:08.071205 | 2022-10-28 01:14:08.071205 | 2022-11-02 04:00:00 | 
 453 |          25 | 95660    | 57.24 | 57.24 | 57.24 |     40 | 2022-10-28 01:14:08.073046 | 2022-10-28 01:14:08.073046 | 2022-11-02 07:00:00 | 
 454 |          26 | E1 7AW   | 59.45 | 55.49 | 62.35 |      0 | 2022-10-28 01:14:08.334357 | 2022-10-28 01:14:08.334357 | 2022-10-28 01:05:23 | 
 455 |          26 | E1 7AW   | 59.65 | 59.65 | 59.85 |      1 | 2022-10-28 01:14:08.62591  | 2022-10-28 01:14:08.62591  | 2022-10-28 10:00:00 | 
 456 |          26 | E1 7AW   | 61.02 | 61.02 | 61.74 |      2 | 2022-10-28 01:14:08.633444 | 2022-10-28 01:14:08.633444 | 2022-10-28 13:00:00 | 
 457 |          26 | E1 7AW   | 64.42 | 64.42 | 64.42 |      3 | 2022-10-28 01:14:08.639973 | 2022-10-28 01:14:08.639973 | 2022-10-28 16:00:00 | 
 458 |          26 | E1 7AW   | 62.89 | 62.89 | 62.89 |      4 | 2022-10-28 01:14:08.645742 | 2022-10-28 01:14:08.645742 | 2022-10-28 19:00:00 | 
 459 |          26 | E1 7AW   | 62.22 | 62.22 | 62.22 |      5 | 2022-10-28 01:14:08.65111  | 2022-10-28 01:14:08.65111  | 2022-10-28 22:00:00 | 
 460 |          26 | E1 7AW   | 58.39 | 58.39 | 58.39 |      6 | 2022-10-28 01:14:08.656062 | 2022-10-28 01:14:08.656062 | 2022-10-29 01:00:00 | 
 461 |          26 | E1 7AW   | 56.26 | 56.26 | 56.26 |      7 | 2022-10-28 01:14:08.661172 | 2022-10-28 01:14:08.661172 | 2022-10-29 04:00:00 | 
 462 |          26 | E1 7AW   | 55.51 | 55.51 | 55.51 |      8 | 2022-10-28 01:14:08.66626  | 2022-10-28 01:14:08.66626  | 2022-10-29 07:00:00 | 
 463 |          26 | E1 7AW   | 57.06 | 57.06 | 57.06 |      9 | 2022-10-28 01:14:08.681712 | 2022-10-28 01:14:08.681712 | 2022-10-29 10:00:00 | 
 464 |          26 | E1 7AW   | 58.21 | 58.21 | 58.21 |     10 | 2022-10-28 01:14:08.693868 | 2022-10-28 01:14:08.693868 | 2022-10-29 13:00:00 | 
 465 |          26 | E1 7AW   | 61.72 | 61.72 | 61.72 |     11 | 2022-10-28 01:14:08.698067 | 2022-10-28 01:14:08.698067 | 2022-10-29 16:00:00 | 
 466 |          26 | E1 7AW   | 67.64 | 67.64 | 67.64 |     12 | 2022-10-28 01:14:08.704692 | 2022-10-28 01:14:08.704692 | 2022-10-29 19:00:00 | 
 467 |          26 | E1 7AW   | 67.91 | 67.91 | 67.91 |     13 | 2022-10-28 01:14:08.718003 | 2022-10-28 01:14:08.718003 | 2022-10-29 22:00:00 | 
```
