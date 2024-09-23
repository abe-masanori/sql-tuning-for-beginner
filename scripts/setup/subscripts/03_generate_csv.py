import datetime
import math
import os
import string
import random
import time

# IDの開始番号（この数字自体は含まない）
start_customer_id = 10000000
start_item_id = 20000000
start_item_category_id = 30000
start_supplier_id = 40000

item_category_count = 1000
supplier_count = 1000

output_dir=os.getenv('TEMP_DIR') +'/'

def get_random_date(start_date, end_date):
    """
    start_dateとend_dateの日付をランダムに取得する（誕生日用）
    """
    diff = (end_date - start_date).days
    random_birthday = start_date + datetime.timedelta(days = random.randint(0, diff))
    return random_birthday.strftime('%Y-%m-%d')

def get_pref_cd():
    """
    都道府県コードを人口比に近い分布で生成する
    """
    pref_cd_list = [
        1,1,1,1,1,1,1,1,2,2,
        3,3,4,4,4,4,5,5,6,6,
        7,7,7,8,8,8,8,8,9,9,
        9,10,10,10,11,11,11,11,11,11,
        11,11,11,11,11,11,12,12,12,12,
        12,12,12,12,12,12,13,13,13,13,
        13,13,13,13,13,13,13,13,13,13,
        13,13,13,13,13,13,13,13,14,14,
        14,14,14,14,14,14,14,14,14,14,
        14,14,14,15,15,15,16,16,17,17,
        18,19,20,20,20,21,21,21,22,22,
        22,22,22,22,23,23,23,23,23,23,
        23,23,23,23,23,23,24,24,24,25,
        25,26,26,26,26,27,27,27,27,27,
        27,27,27,27,27,27,27,27,27,28,
        28,28,28,28,28,28,28,28,29,29,
        30,31,32,33,33,33,34,34,34,34,
        35,35,36,37,37,38,38,39,40,40,
        40,40,40,40,40,40,41,42,42,43,
        43,43,44,44,45,45,46,46,46,47,47
    ]
    return pref_cd_list[random.randint(0,200)]

def generate_customers(row_count):
    """
    customersテーブルのデータを生成する
    """
    start_time = time.time()
    
    birthday_start = datetime.datetime(1940, 1,1)
    birthday_end = datetime.datetime(2010, 12, 31)

    with open(output_dir + 'customers.csv', mode = 'w', newline = '\n') as f:
        print('customers.csvを生成中...', end = '', flush =True)
        for i in range(1, row_count + 1):
            pref_cd = str(get_pref_cd())
            customer_id = str(i + start_customer_id)

            f.write('\t'.join([
                customer_id,
                'cust_name_' + customer_id,
                'address_001_' + customer_id,
                'address_002_' + customer_id,
                '090' + customer_id,
                get_random_date(birthday_start, birthday_end),
                pref_cd,
                pref_cd.zfill(2) + str(random.randint(1, 1000)).zfill(4)
            ]))
            f.write('\n')
        
        end_time = time.time()
        print('完了（' + str(round(end_time - start_time)) +'s）')

def generate_items(row_count):
    """
    itemsテーブルのデータを生成する
    """
    start_time = time.time()
    
    with open(output_dir + 'items.csv', mode = 'w', newline = '\n') as f:
        print('items.csvの生成中...', end = '', flush =True)
        for i in range(1, row_count + 1):
            item_id = str(i + start_item_id)

            f.write('\t'.join([
                item_id,
                'item_ABCDEFGHIJKLMNOP_' + item_id,
                str(random.randint(start_item_category_id + 1, start_item_category_id + item_category_count)),
                str(random.randint(start_supplier_id + 1, start_supplier_id + supplier_count)),
            ]))
            f.write('\n')
        
        end_time = time.time()
        print('完了（' + str(round(end_time - start_time)) +'s）')

def get_random_customer_id(customer_count):
    """
    顧客IDをパレート分布と一様分布を組み合わせて生成する
    """
    rand_i = 0
    rand_f = random.paretovariate(50.0) - 1.0

    if (random.randint(0, 1) == 0) and (rand_f < 5.0):
        rand_i = math.floor(rand_f / 5 * customer_count) + 1
    else:
        rand_i = random.randint(1, customer_count)

    return str(rand_i + start_customer_id)

def get_random_item_id(item_count):
    """
    商品IDをパレート分布と一様分布を組み合わせて生成する
    """
    rand_i = 0
    rand_f = random.paretovariate(100.0) - 1.0

    if (random.randint(0, 1) == 0) and (rand_f < 5.0):
        rand_i = math.floor(rand_f / 5 * item_count) + 1
    else:
        rand_i = random.randint(1, item_count)

    return str(rand_i + start_item_id)

def generate_orders(days, row_count_per_day, customer_count, item_count):
    """
    ordersテーブルのデータを生成する
    """
    start_time = time.time()
    
    order_id = 500000001
    start_date = datetime.datetime(2023, 1, 1)

    with open(output_dir + 'orders.csv', mode = 'w', newline = '\n') as f:
        print('orders.csvを生成中...', end = '', flush =True)
        for day_count in range(days):
            order_date = (start_date + datetime.timedelta(days = day_count)).strftime('%Y-%m-%d')

            for i in range(row_count_per_day):
                f.write('\t'.join([
                    str(order_id),
                    order_date,
                    get_random_customer_id(customer_count),
                    get_random_item_id(item_count),
                    str(random.randint(1000, 2000)),
                    str(random.randint(1, 10))
                ]))
                f.write('\n')

                order_id = order_id + 1
        
        end_time = time.time()
        print('完了（' + str(round(end_time - start_time)) +'s）')

if __name__ == '__main__':
    random.seed(20240908)
    generate_customers(5000000)
    generate_items(10000000)
    generate_orders(500, 100000, 5000000, 10000000)