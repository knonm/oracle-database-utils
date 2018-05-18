SELECT chain_cnt,
       ROUND(chain_cnt/num_rows*100,2) pct_chained,
       avg_row_len, pct_free , pct_used
FROM   user_tables
WHERE  table_name = 'ROW_MIG_CHAIN_DEMO';
