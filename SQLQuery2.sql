select * FROM [housing sql data cleansing].[dbo].[Nashville Housing Data for Data Cleaning]


-- PropertyAddress data
/* As property address is not changable and we are populating the null value using ParcelID value also using 
UniqueId */
select PropertyAddress FROM [housing sql data cleansing].[dbo].[Nashville Housing Data for Data Cleaning]
where PropertyAddress is null


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
FROM [housing sql data cleansing].[dbo].[Nashville Housing Data for Data Cleaning] a
join [housing sql data cleansing].[dbo].[Nashville Housing Data for Data Cleaning] b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null

update a
set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
FROM [housing sql data cleansing].[dbo].[Nashville Housing Data for Data Cleaning] a
join [housing sql data cleansing].[dbo].[Nashville Housing Data for Data Cleaning] b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null



-- Breaking down the Address into individual column (Address, city and state)
select 
substring (PropertyAddress, 1, charindex(',', PropertyAddress) -1) as Address,
substring(PropertyAddress, charindex(',', PropertyAddress) + 1, len(PropertyAddress)) as Address
FROM [housing sql data cleansing].[dbo].[Nashville Housing Data for Data Cleaning]


alter table [dbo].[Nashville Housing Data for Data Cleaning]
add PropertySplitAddress Nvarchar(255);

update [dbo].[Nashville Housing Data for Data Cleaning]
set PropertySplitAddress = substring (PropertyAddress, 1, charindex(',', PropertyAddress) -1) 


alter table [dbo].[Nashville Housing Data for Data Cleaning]
add PropertySplitCity Nvarchar(255);

update [dbo].[Nashville Housing Data for Data Cleaning]
set PropertySplitCity = substring(PropertyAddress, charindex(',', PropertyAddress) + 1, len(PropertyAddress))


select * from [housing sql data cleansing].[dbo].[Nashville Housing Data for Data Cleaning]


-- OwnerAddress
select OwnerAddress
 from [housing sql data cleansing].[dbo].[Nashville Housing Data for Data Cleaning]


select 
parsename(replace(OwnerAddress, ',', '.'), 3),
parsename(replace(OwnerAddress, ',', '.'), 2),
parsename(replace(OwnerAddress, ',','.'), 1)
from [housing sql data cleansing].[dbo].[Nashville Housing Data for Data Cleaning]


alter table [dbo].[Nashville Housing Data for Data Cleaning]
add OwnerSplitAddress Nvarchar(255);

update [dbo].[Nashville Housing Data for Data Cleaning]
set OwnerSplitAddress = parsename(replace(OwnerAddress, ',', '.'), 3)


alter table [dbo].[Nashville Housing Data for Data Cleaning]
add OwnerSplitCity Nvarchar(255);

update [dbo].[Nashville Housing Data for Data Cleaning]
set OwnerSplitCity = parsename(replace(OwnerAddress, ',', '.'), 2)



alter table [dbo].[Nashville Housing Data for Data Cleaning]
add OwnerSplitState Nvarchar(255);

update [dbo].[Nashville Housing Data for Data Cleaning]
set OwnerSplitState = parsename(replace(OwnerAddress, ',', '.'), 1)


select *
 from [housing sql data cleansing].[dbo].[Nashville Housing Data for Data Cleaning]


 -- Changing Y and N for Yes and No for SoldAsVaccant field
 select distinct(SoldAsVacant), count(SoldAsVacant)
 from [housing sql data cleansing].[dbo].[Nashville Housing Data for Data Cleaning]
 group by SoldAsVacant
 order by 2 

 /* this case is only used if we have "Yes", "No", "Y", "N" value in the SoldAsVacant column
 select 
 case 
	when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
end
 from [housing sql data cleansing].[dbo].[Nashville Housing Data for Data Cleaning]

update [dbo].[Nashville Housing Data for Data Cleaning]
set SoldAsVacant = case 
	when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
end
*/


-- Removing Duplicates
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

from [housing sql data cleansing].[dbo].[Nashville Housing Data for Data Cleaning]
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
from [housing sql data cleansing].[dbo].[Nashville Housing Data for Data Cleaning]




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
from [housing sql data cleansing].[dbo].[Nashville Housing Data for Data Cleaning]


ALTER TABLE [dbo].[Nashville Housing Data for Data Cleaning]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate


Select *
from [housing sql data cleansing].[dbo].[Nashville Housing Data for Data Cleaning]