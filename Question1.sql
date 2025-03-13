WITH museum_painting_count AS (
    -- Count total paintings per museum
    SELECT 
        w.museum_id, 
        COUNT(*) AS total_paintings
    FROM work w
    GROUP BY w.museum_id
),
cubist_paintings AS (
    -- Count paintings created by artists with the "Cubist" style
    SELECT 
        w.museum_id, 
        COUNT(*) AS cubist_count
    FROM work w
    JOIN artist a ON w.artist_id = a.artist_id
    WHERE a.style = 'Cubist'  -- Using artist's style instead of work's style
    GROUP BY w.museum_id
)
SELECT 
    m.name AS museum_name,
    c.cubist_count, 
    t.total_paintings,
    ROUND((c.cubist_count::DECIMAL / t.total_paintings) * 100, 2) AS cubist_percentage
FROM museum_painting_count t
JOIN cubist_paintings c ON t.museum_id = c.museum_id
JOIN museum m ON t.museum_id = m.museum_id
ORDER BY cubist_percentage DESC
LIMIT 10;

--part 2

WITH top_cubist_museums AS (
    -- Get top 10 museums with the highest proportion of Cubist paintings
    WITH museum_painting_count AS (
        SELECT 
            w.museum_id, 
            COUNT(*) AS total_paintings
        FROM work w
        GROUP BY w.museum_id
    ),
    cubist_paintings AS (
        SELECT 
            w.museum_id, 
            COUNT(*) AS cubist_count
        FROM work w
        JOIN artist a ON w.artist_id = a.artist_id
        WHERE a.style = 'Cubist'
        GROUP BY w.museum_id
    )
    SELECT 
        m.museum_id,
        m.name AS museum_name,  -- This column is correctly selected here
        ROUND((c.cubist_count::DECIMAL / t.total_paintings) * 100, 2) AS cubist_percentage
    FROM museum_painting_count t
    JOIN cubist_paintings c ON t.museum_id = c.museum_id
    JOIN museum m ON t.museum_id = m.museum_id
    ORDER BY cubist_percentage DESC
    LIMIT 10
)
-- Find other styles in these museums
SELECT 
    tcm.museum_name,  -- Use the correct alias from top_cubist_museums
    w.style, 
    COUNT(*) AS style_count
FROM work w
JOIN top_cubist_museums tcm ON w.museum_id = tcm.museum_id
WHERE w.style IS NOT NULL AND w.style <> 'Cubist'
GROUP BY tcm.museum_name, w.style
ORDER BY tcm.museum_name,style_count DESC;

