-- data explorating

select * from portfolio..Nashville

-- standarize data format

select SaleDate, CONVERT(date,SaleDate) 
from portfolio..Nashville


alter table portfolio..Nashville
add  SaleDate2 date 

Update portfolio..Nashville
set SaleDate2 = CONVERT(date,SaleDate) 

select saleDate2
from  portfolio..Nashville

--populate property adrees date 


select *
from portfolio..Nashville
where PropertyAddress is null


select  a.ParcelID , a.PropertyAddress ,b.ParcelID ,b.PropertyAddress
from portfolio..Nashville a
join  portfolio..Nashville b
on a.ParcelID=b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from portfolio..Nashville a
join  portfolio..Nashville b
on a.ParcelID=b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null



--breaking adress into adress city state

select PropertyAddress
from portfolio..Nashville

select
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) - 1) as adress , 
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) + 1,LEN(PropertyAddress)) as city ,
PARSENAME(REPLACE(OwnerAddress,',' ,'.'), 1) as state
from portfolio..Nashville

alter table portfolio..Nashville
add  Adress nvarchar(255)

Update portfolio..Nashville
set Adress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) - 1)


alter table portfolio..Nashville
add  City nvarchar(255)

Update portfolio..Nashville
set City = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) + 1,LEN(PropertyAddress))

alter table portfolio..Nashville
add  state nvarchar(255)

Update portfolio..Nashville
set state = PARSENAME(REPLACE(OwnerAddress,',' ,'.'), 1)

select *
from portfolio..Nashville

-- change Y to Yes and N to No in the SoldAsVacant
 
 select count(SoldAsVacant)
 from portfolio..Nashville
 where SoldAsVacant like 'Y' or SoldAsVacant like 'N'

 update portfolio..Nashville
 SET SoldAsVacant = 'No'
 where SoldAsVacant like 'N'

  update portfolio..Nashville
 SET SoldAsVacant = 'Yes'
 where SoldAsVacant like 'Y'


 -- remove duplicates
 with row_numCTE as(
 select * ,ROW_NUMBER() over (partition by parcelID,
                                           propertyAddress,
										   saleprice,
										   saledate,
										   legalreference
										   order by uniqueID) row_num

 from portfolio..Nashville
 --order by ParcelID
 )
 --delete
 select * 
 from row_numCTE 
 where row_num > 1
 order by PropertyAddress


 --delete unused columns


 alter table portfolio..Nashville
 drop column PropertyAddress,TaxDistrict,OwnerAddress,SaleDate



