/*
 * Copyright (c) 2020.  adelForce (Adelchi Ltd)
 *  All Rights Reserved
 *  NOTICE:  All information contained herein is, and remains the property of adelForce (Adelchi Ltd) .
 *  The intellectual and technical concepts contained are protected by trade secret or copyright law.
 *  Dissemination of this information or reproduction of this material is strictly forbidden unless prior written permission is obtained from  adelForce (Adelchi Ltd).
 */
/**
 * Created by Adelchi on 08/05/2020.
 */


public class AnalyzeObject {

    public class fieldReqInfo {
        public String fldName {get; set;}
        public String fldType {get; set;}
        public fieldReqInfo(String n, String t) {
            fldName = n;
            fldType = t;
        }
    }

    public static List<fieldReqInfo> getRequiredFieldInfo(String Obj){
        Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(obj).getDescribe().fields.getMap();
        List<String> lst = new List<String>(objectFields.keySet());
        List<fieldReqInfo> fldI = new List<AnalyzeObject.fieldReqInfo>();
        List<String> allReqFields = getRequiredFieldsName(Obj);
        System.debug(allReqFields.size()+ ' required fields ');
        for(Integer i=0; i<objectFields.size(); i++){
            for(String s : allReqFields){
                if(s==lst.get(i)){
                    fldI.add(new fieldReqInfo(s, String.valueOf(objectFields.values()[i].getDescribe().getType())));
//                    System.debug(fldI[i]);
                }
            }
        }
        return fldI;

    }

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
                if(!F.isNillable() && F.getType()!= Schema.DisplayType.ID && F.getType()!= Schema.DisplayType.DATETIME && F.getType()!= Schema.DisplayType.DATE && !F.isAutoNumber() && !F.isCalculated() && F.getType()!=Schema.DisplayType.REFERENCE)
                {
                    reqFields.add(fieldName );
                    system.debug(fieldName);
                }
            }

        }
        return reqFields;
    }

    public static List<String> getFieldsType(String selectedObj){
        List<String> reqFields = new List<String>();
        if(selectedObj!=null){
            Map <String,Schema.SObjectType> gd = Schema.getGlobalDescribe();
            Schema.SObjectType sobjType = gd.get(selectedObj);
            Schema.DescribeSObjectResult r = sobjType.getDescribe();
            Map<String, Schema.SObjectField> MapofField = r.fields.getMap();
            for(String fieldName : MapofField.keySet()) {
                Schema.SObjectField field = MapofField.get(fieldName);
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
        return 'Object';                    // actually we can't detect maps and sets
    }

    public static boolean hasSObjectField(String fieldName, String so){
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        return gd.get(so).getDescribe().fields.getMap().keySet().contains(fieldName.toLowerCase());
    }
}