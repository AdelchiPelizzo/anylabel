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

    public static string getTypeOf(Object o) {
        if(o==null) return '';              // we can't say much about null with our current techniques
        if(o instanceof SObject)            return ((SObject)o).getSObjectType().getDescribe().getName()+'';
        if(o instanceof Boolean)            return 'Boolean';
        if(o instanceof Id)                 return 'Id';
        if(o instanceof String)             return 'String';
        if(o instanceof Blob)               return 'Blob';
        if(o instanceof Date)               return 'Date';
        if(o instanceof Datetime)           return 'Datetime';
        if(o instanceof Time)               return 'Time';
        if(o instanceof String)             return 'String';
        if(o instanceof Integer)            return 'Integer';
        if(o instanceof Long)               return 'Long';
        if(o instanceof Decimal)            return 'Decimal';  // we can't distinguish between decimal and double
        if(o instanceof Double)             return 'Double';   // we can't distinguish between decimal and double
        if(o instanceof List<object>)       return 'List';
        return 'Object';                    // actually we can't detect maps and sets and maps
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