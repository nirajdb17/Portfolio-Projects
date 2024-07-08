select * 
from PortfolioProject.dbo.NashvilleHousing


-- standardize date format

select SaleDate, CONVERT(Date,SaleDate)
from PortfolioProject..NashvilleHousing

update NashvilleHousing 
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
ADD Converted Date;

update NashvilleHousing 
SET Converted = CONVERT(Date,SaleDate);



-- Property Address

select *
from PortfolioProject..NashvilleHousing
--where PropertyAddress is NULL
order by ParcelID


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress,
ISNULL(a.PropertyAddress, b.PropertyAddress) as NP
from PortfolioProject..NashvilleHousing as a 
JOIN PortfolioProject..NashvilleHousing as b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]

where a.PropertyAddress is NULL

update a
SET PropertyAddress  = ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing as a 
JOIN PortfolioProject..NashvilleHousing as b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is NULL


-- dividing address into columns

select PropertyAddress
from PortfolioProject..NashvilleHousing
--where PropertyAddress is NULL
--order by ParcelID


select 
substring(PropertyAddress,1,CHARINDEX(',', PropertyAddress) -1) AS address,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress)) as Address

from PortfolioProject..NashvilleHousing


ALTER TABLE NashvilleHousing
ADD PropertySplitAddress Nvarchar(255);

update NashvilleHousing 
SET PropertySplitAddress = substring(PropertyAddress,1,CHARINDEX(',', PropertyAddress) -1);

ALTER TABLE NashvilleHousing
ADD PropertyCityAddress Nvarchar(255);

update NashvilleHousing 
SET PropertyCityAddress = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress));

select * from PortfolioProject..NashvilleHousing



select 
PARSENAME(REPLACE(OwnerAddress, ',','.') , 3),
PARSENAME(REPLACE(OwnerAddress, ',','.') , 2),
PARSENAME(REPLACE(OwnerAddress, ',','.') , 1)
from PortfolioProject..NashvilleHousing



ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255);

update NashvilleHousing 
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.') , 3);

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity Nvarchar(255);

update NashvilleHousing 
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.') , 2);

ALTER TABLE NashvilleHousing
ADD OwnerSplitState Nvarchar(255);

update NashvilleHousing 
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.') , 1);


select * from PortfolioProject..NashvilleHousing


select distinct (SoldAsVacant), count(SoldAsVacant)
from PortfolioProject..NashvilleHousing
group by SoldAsVacant
order by 2


select SoldAsVacant ,
CASE when SoldAsVacant = 'y' then 'Yes'
     when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant end
from PortfolioProject..NashvilleHousing

update NashvilleHousing
SET SoldAsVacant = CASE when SoldAsVacant = 'y' then 'Yes'
     when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant end


	 -- removing duplicates

	 with rownumCTE as(
	 select *, 
	 ROW_NUMBER() OVER(
	 PARTITION BY ParcelID,
	              PropertyAddress,
				  SalePrice,
				  SaleDate,
				  LegalReference
				  order by UniqueID
				  ) row_num
	 from PortfolioProject..NashvilleHousing
	 )
	 select * 
	 from rownumCTE
	 where row_num > 1
	 --order by PropertyAddress



	 -- removing unused columns
select * 
from PortfolioProject..NashvilleHousing

alter table PortfolioProject..NashvilleHousing
drop column OwnerAddress, Taxdistrict, PropertyAddress

alter table PortfolioProject..NashvilleHousing
drop column SaleDate