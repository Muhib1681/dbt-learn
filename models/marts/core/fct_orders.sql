with ft_orders as (

    select stg_payments.order_id,
        stg_orders.customer_id,
        stg_payments.amount
    from {{ ref('stg_payments') }} as stg_payments
    join {{ ref('stg_orders') }} as stg_orders using (order_id)
    where stg_payments.status = 'success'
)

select * from ft_orders