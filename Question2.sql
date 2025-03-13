SELECT 
    a.full_name AS artist_name,
    COUNT(DISTINCT m.country) AS country_count
FROM work w
JOIN artist a ON w.artist_id = a.artist_id
JOIN museum m ON w.museum_id = m.museum_id
WHERE m.country IS NOT NULL  -- Ensure we only count valid country data
GROUP BY a.full_name
ORDER BY country_count DESC
LIMIT 10;  -- Get top 10 artists with the most international presence
