# dbt_superstore 
Простой ELT Pipeline по построению витрин данных (измерения и факты) на основе данных из прошлых модулей курса DataLearn.
Данные загружаются в схему superstore в таблицы `orders` (данные с заказами), `returns` (заказы, которые вернули), `people` (менеджеры регионов), которые мы обозначим как sources в dbt.  
На основе этих источников, построим модели `stg_superstore__orders`, `stg_superstore__people` и `stg_superstore__returns` материализуя их как views и напишем тесты для проверки на остуствие null значении, на уникальность, на равенство элементов некоторых столбцов на множество разрешенных значений и на отстуствие логических ошибок в данных.  
После этого, используя эти представления, будут создаваться модели, а именно витрины (в формате views): `dim_customers` - измерение с покупателями, `dim_deliver` - измерение с точками доставки заказов, `dim_ship` - измерение с информацией о способе доставки, `fct_orders` - представление с фактами о заказах, `fct_products` - представление с фактами о проданных продуктах.  
В итоге DAG dbt выглядит следующим образом:  
  
<img src="https://github.com/f0rest-mAker/dbt_superstore_project/blob/main/img/dbt_DAG.png" width="800">  

А база данных имеет следующую структуру:  
  
<img src="https://github.com/f0rest-mAker/dbt_superstore_project/blob/main/img/database.png" width="400">

В схеме superstore хранятся таблицы, куда будут загружаться данные и откуда будут браться данные на формирование витрин данных. В схеме dev будут создаваться все представления.
