import pandas as pd
df=pd.read_csv("C:/Users/Hashir/Downloads/customer_shopping_behavior.csv")
print(df.head())
df.info()

print(df.describe(include="all"))



print(df.isnull().sum())
df['Review Rating']= df.groupby('Category')['Review Rating'].transform(lambda x: x.fillna(x.median()))
print(df.isnull().sum())





df.columns =df.columns.str.lower()
df.columns =df.columns.str.replace(' ','_')
print(df.columns)
df =df.rename(columns={'purchase_amount_(usd)':'purchase_amount'})
print(df.columns)




labels=['Young Adult','Adult','Middle aged','Senior']
df['age_group']=pd.qcut(df['age'],q=4,labels=labels)
print(df[['age','age_group']].head(10))



frequency_mapping={
    'Fortnightly': 14,
    'Weekly':7,
    'Monthly': 30,
    'Quarterly': 90,
    'Bi-Weekly' : 14,
    'Annually' : 365,
    'Every 3 Months' : 90
}
df['purchase_frequency_days']=df['frequency_of_purchases'].map( frequency_mapping)



df= df.drop('promo_code_used',axis=1)

import mysql.connector

conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password="mohd9848625783",
    database="customer_shopping_behavior"
)

print("Connected successfully")

from sqlalchemy import create_engine

engine = create_engine("mysql+mysqlconnector://root:mohd9848625783@localhost/customer_shopping_behavior")

df.to_sql("customers", con=engine, if_exists="replace", index=False)

print("Data uploaded successfully!")