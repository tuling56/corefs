set names utf8;
SELECT 
    c.mon,
    c.fdim_pos_detail,
    c.tcnt,
    SUM(CASE
        WHEN c.fdim_business = 'vip' THEN c.bratio
        ELSE 0
    END) AS '会员',
    SUM(CASE
        WHEN c.fdim_business LIKE '%game%' THEN c.bratio
        ELSE 0
    END) AS '游戏',
    SUM(CASE
        WHEN c.fdim_business = 'exchange' THEN c.bratio
        ELSE 0
    END) AS '换量',
    SUM(CASE
        WHEN c.fdim_business = 'jiasuqi' THEN c.bratio
        ELSE 0
    END) AS '加速器',
    SUM(CASE
        WHEN c.fdim_business = 'kuainiao' THEN c.bratio
        ELSE 0
    END) AS '快鸟',
    SUM(CASE
        WHEN c.fdim_business = 'finance' THEN c.bratio
        ELSE 0
    END) AS '金融',
    SUM(CASE
        WHEN c.fdim_business = 'adv' THEN c.bratio
        ELSE 0
    END) AS '广告',
    SUM(CASE
        WHEN c.fdim_business = 'zhuanqianbao' THEN c.bratio
        ELSE 0
    END) AS '赚钱宝',
    SUM(CASE
        WHEN c.fdim_business = 'xllive' THEN c.bratio
        ELSE 0
    END) AS '直播',
    SUM(CASE
        WHEN c.fdim_business = 'offline' THEN c.bratio
        ELSE 0
    END) AS '离线',
    SUM(CASE
        WHEN c.fdim_business = 'other' THEN c.bratio
        ELSE 0
    END) AS '其它'
FROM
        (SELECT
            a.mon AS mon,
            a.fdim_pos_detail AS fdim_pos_detail,
            b.tcnt as tcnt,
            a.fdim_business AS fdim_business,
            ROUND(a.cnt / b.tcnt, 4) AS bratio
        FROM
            (SELECT
                SUBSTR(ftime, 1, 6) AS mon,
                    fdim_pos_detail,
                    fdim_business,
                    SUM(ffact_expo_cnt) AS cnt
            FROM
                complat_stat_fact.ftbl_flow_business_expo_click
            WHERE
                ftime >= 'start_ftime'
					AND ftime <= 'end_ftime'
            GROUP BY fdim_pos_detail , fdim_business) a
                INNER JOIN
            (SELECT 
                SUBSTR(ftime, 1, 6) AS mon, 
                fdim_pos_detail,
                SUM(ffact_expo_cnt) AS tcnt
            FROM
                complat_stat_fact.ftbl_flow_business_expo_click
            WHERE
                ftime >= 'start_ftime'
					AND ftime <= 'end_ftime'
            GROUP BY fdim_pos_detail) b 
            ON a.mon = b.mon
              AND a.fdim_pos_detail = b.fdim_pos_detail)c
GROUP BY c.mon,c.fdim_pos_detail;
