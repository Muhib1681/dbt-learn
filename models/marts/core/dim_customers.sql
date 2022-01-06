with customers as (

    select * from {{ ref('stg_customers') }}

),

orders as (

    select * from {{ ref('stg_orders') }}

),

customer_orders as (

    select
        customer_id,

        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders

    from orders

    group by 1

),

ft_order as 
(

    select ft.customer_id, sum(amount) as life_time_value
    from {{ ref('fct_orders') }} ft
    group by ft.customer_id
),

final as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders,
        ft_order.life_time_value

    from customers

    left join customer_orders using (customer_id)
    left join ft_order using (customer_id)

)


select * from final