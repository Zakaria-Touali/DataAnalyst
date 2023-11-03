select * from portfolio..shopping

select category , season , size ,PromoCodeUsed , PaymentMethod
from portfolio..shopping
where PromoCodeUsed like 'No'
order by season,category


--Ordering Most catgories that people gender don't use promo code on it USING A CTE

with Temp(season,category,gender,CountOfNonPromoUser)
as (
select season,category,gender,COUNT(PromoCodeUsed) as CountOfNonPromoUser
from portfolio..shopping
where PromoCodeUsed like 'No'
group by season,category,gender) 
select * from Temp
Order by Temp.CountOfNonPromoUser desc


--The Most Used Payment Methods


with PayTabTemp(PaymentMethod,category,gender,CountOfPayMethod)
as (
select PaymentMethod,category,gender,COUNT(PaymentMethod) as CountOfPayMethod
from portfolio..shopping
group by PaymentMethod,category,gender
)
select * from PayTabTemp
order by CountOfPayMethod desc


--the most shipping type used in every season

with ShippingTemp(ShippingType,season,gender,CountOfShippingType)
as (
select ShippingType,season,gender,COUNT(ShippingType) as CountOfShippingType
from portfolio..shopping
group by ShippingType,season,gender
)
select * from ShippingTemp
order by CountOfShippingType desc