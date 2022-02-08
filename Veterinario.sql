SELECT PetID, Kind, Gender, Age
FROM pets

SELECT OwnerID, Name, Surname, StreetAddress, City
FROM owners

CREATE TABLE vetscli
(PetID nvarchar(50),
OwnerID nvarchar(50),
ProcedureType varchar(50),
ProcedureSubCode int,
Description varchar(50),
Price int,
Dia date
)
INSERT INTO vetscli
SELECT p.PetID,o.OwnerID, ph.ProcedureType, ph.ProcedureSubCode,Description, Price, Date
FROM owners AS o
LEFT JOIN Pets as p
	 on o.OwnerID = p.OwnerID
LEFT JOIN procedures_history as ph
	on p.PetID = ph.PetID
LEFT JOIN procedures_details as pd
	 on ph.ProcedureType = pd.ProcedureType
	 and ph.ProcedureSubCode = pd.ProcedureSubCode
WHERE ph.PetID IS NOT NULL

 
UPDATE vetscli
SET Description = 'Radical Mastectomy', Price = 450
WHERE PetID LIKE 'J1-6366'

SELECT *
FROM vetscli

