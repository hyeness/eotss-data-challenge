/* SQL */

create table ga_session_views
(
    session_id text, -- id associated with a particular session (see here for more information https://support.google.com/analytics/answer/2731565?hl=en)
    hit_timestamp timestamp, - time (to the minute level) when a user hit a page
    node_id integer, -- id of page that was hit
    pageviews integer - number of times the user hit a page
);

create table ga_session_features
(
    session_id text, -- unique session identifier, matches with session_id from ga_session_views, primary key
    medium text, -- way the user came to the site including: organic, direct, referral
    device_category text, -- type of device the user used options are: mobile, desktop, tablet
    browser text -- type of browser user used:
);


/* Questions */

/* 1. Write a query that shows how many pageviews occurred in the last week */

SELECT SUM(pageviews), WEEKOFYEAR(hit_timestamp) AS week
FROM ga_session_views
GROUP BY week
ORDER BY week DESC
LIMIT 1;

/* 2. How many sessions have organic as a medium? */

SELECT COUNT(*)
FROM ga_session_features
WHERE medium = 'organic';

/* 3. Create a list of all nodes with the amount of pageviews
that came from users with an organic medium in the last 30 days
with the highest number first */

SELECT DAYOFYEAR(gsv.hit_timestamp)AS hitdate, gsv.node_id, gsf.medium, gsv.pageviews
FROM ga_session_views gsv
JOIN ga_session_features gsf ON gsv.session_id = gsf.session_id
WHERE gsf.medium = ‘organic’
AND hitdate BETWEEN DATEADD(DAY, -30, GETDATE()) AND GETDATE()
ORDER BY gsv.pageviews DESC;

/* 4. How many pageviews occurred at each hour of the day for each device? */

SELECT gsf.device, SUM(gsv.pageviews), DATE_FORMAT(gsv.hit_timestamp, %H) AS hithour
FROM ga_session_views gsv
JOIN ga_session_features gsf ON gsv.session_id = gsf.session_id
GROUP BY gsf.device, hithour
ORDER BY hithour;
