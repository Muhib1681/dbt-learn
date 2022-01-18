with customers as (

    select * from {{ ref('stg_customers') }}

),

ft_orders as (

    select * from {{ ref('fct_orders') }}

),

customer_orders as (

    select
        customers.customer_id,

        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders,
        sum(amount) as life_time_value

    from fct_orders
    left join customers using(customer_id)

    group by customers.customer_id

),

final as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders,
        customer_orders.life_time_value

    from customers

    left join customer_orders using (customer_id)
    left join ft_orders using (customer_id)

)


select * from final