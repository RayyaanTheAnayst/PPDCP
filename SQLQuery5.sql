

-- Change Date format to a more usable format, using UPDATE and Convert


SELECT*
FROM PortfolioProject.dbo.NashvilleHousing

SELECT SaleDate
FROM PortfolioProject.dbo.NashvilleHousing

SELECT SaleDateConverted, CONVERT(DATE, SaleDate)
FROM PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD SaleDateConverted DATE;

UPDATE PortfolioProject.dbo.NashvilleHousing
SET SaleDateConverted = CONVERT(DATE, SaleDate)

------------------------------------------------------------------------------------------------

--Populate Property Address, populate data for  Null values in  property address by JOINING, using ISNULL, UPDATE


SELECT*
FROM PortfolioProject.dbo.NashvilleHousing
WHERE PropertyAddress IS NULL

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
FROM PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
on  a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL


-- Use ISNULL to fill a.PropertyAddress with b.PropertyAddress


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
on  a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
on  a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

---------------------------------------------------------------------------------------------------
--- Breaking up Address into individual Colums ie Address, City, State)

SELECT PropertyAddress
FROM PortfolioProject.dbo.NashvilleHousing

-- Substring, Character index "CHARINDEX" to get rid of the comma

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address,								--- REMOVES COMMA
SUBSTRING(PropertyAddress,    CHARINDEX(',', PropertyAddress)+1 ,LEN(PropertyAddress)) AS Address			--- moves everything after the comma

FROM PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing															--- create new colum Address_split
ADD Address_split NVARCHAR(255);

UPDATE PortfolioProject.dbo.NashvilleHousing																--- Fills Address_split with data
SET Address_split = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)


ALTER TABLE PortfolioProject.dbo.NashvilleHousing															--- create new colum City_split
ADD City_split NVARCHAR(255);				

UPDATE PortfolioProject.dbo.NashvilleHousing																--- Fills City_split with data	
SET City_split = SUBSTRING(PropertyAddress,    CHARINDEX(',', PropertyAddress)+1 ,LEN(PropertyAddress))



SELECT*
FROM PortfolioProject.dbo.NashvilleHousing																	--- Test to review changes 





--------------------------------------------------------------------------------------------------------------

-- Owner Address split into ADDRESS/CITY and STATE USING PARSENAME

SELECT OwnerAddress
FROM PortfolioProject.dbo.NashvilleHousing


SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

FROM PortfolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing															--- create new colum Owner_Address
ADD Owner_Address NVARCHAR(255);

UPDATE PortfolioProject.dbo.NashvilleHousing																--- Fills Owner_Address with data
SET Owner_Address = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE PortfolioProject.dbo.NashvilleHousing															--- create new colum Owner_City
ADD Owner_City NVARCHAR(255);

UPDATE PortfolioProject.dbo.NashvilleHousing																--- Fills Owner_City with data
SET Owner_City = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE PortfolioProject.dbo.NashvilleHousing															--- create new colum Owner_State
ADD Owner_State NVARCHAR(255);

UPDATE PortfolioProject.dbo.NashvilleHousing																--- Fills Owner_State with data
SET Owner_State = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


----------------------------------------------------------------------------------------------
-- CHANGE Y/N TO YES/NO in SoldAsVacabt column USING  DISTINCT to check responce numbers then CASE

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)		-- looked for distinct answers and did a count; Word > letters change  Y--> Yes
FROM PortfolioProject.dbo.NashvilleHousing
GROUP BY SoldAsVacant


SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
	   WHEN SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END
FROM PortfolioProject.dbo.NashvilleHousing

UPDATE PortfolioProject.dbo.NashvilleHousing
SET SoldAsVacant =  CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
					WHEN SoldAsVacant = 'N' THEN 'NO'
					ELSE SoldAsVacant
					END





--------------------------------------------------------------------------------

--- REMOVE Columns 

SELECT*
FROM PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress