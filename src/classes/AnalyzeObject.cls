/**
 * Created by Adelchi on 08/05/2020.
 * Purpose : (Write a succinct description of this class here.)
 */


public class AnalyzeObject {
    /**
 * Purpose : (Write a succinct description of this method here.)
 * @param (parameter name) (Describe the first parameter here)
 * @param (parameter name) (Do the same for each additional parameter)
 * @return (description of the return value)
 */


    public static List<String> getRequiredFieldsName(String selectedObj){
        List<String> reqFields = new List<String>();
        if(selectedObj!=null){

            Map <String,Schema.SObjectType> gd = Schema.getGlobalDescribe();
            Schema.SObjectType sobjType = gd.get(selectedObj);
            Schema.DescribeSObjectResult r = sobjType.getDescribe();
            Map<String, Schema.SObjectField> MapofField = r.fields.getMap();
            for(String fieldName : MapofField.keySet()) {
                Schema.SObjectField field = MapofField .get(fieldName);
                Schema.DescribeFieldResult F = field.getDescribe();
                if( F.isCreateable() && !F.isNillable() &&  F.getName()!='OwnerId' )
                {
                    reqFields.add(fieldName );
                }
            }

        }
        return reqFields;
    }


//    Schema.DescribeSObjectResult r = System.ObjectType.getDescribe();
//    Map<String,Schema.SObjectField> M = r.fields.getMap();
//    for(String fieldName : M.keySet())
//    {
//    Schema.SObjectField field = M.get(fieldName);
//    Schema.DescribeFieldResult F = field.getDescribe();
//    //A nillable field can have empty content. A isNillable Boolean non-nillable field must have a value for the object to be                       //created or saved.
//    // if F.isNillable() is false then field is mandatory
//    Boolean isFieldreq  = F.isNillable()
            }