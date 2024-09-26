let
    Source = CostAnalysis,
    Main_table_Table = Source{[Item="Main_table",Kind="Table"]}[Data],
    #"Changed Type" = Table.TransformColumnTypes(Main_table_Table,{{"Date", type date}, {"ID_Key_Item", type text}, {"Value (kUSD)", type number}, {"ID_Key_Line", Int64.Type}, {"ID_Key_Allocation", Int64.Type}, {"ID_Key_Type", Int64.Type}}),
    #"Added Custom" = Table.AddColumn(#"Changed Type", "Value_reverse", each try if Text.Contains(Text.Upper([ID_Key_Item]), "COST") then -[#"Value (kUSD)"] else [#"Value (kUSD)"] otherwise [#"Value (kUSD)"]),
    #"Added Custom2" = Table.AddColumn(#"Added Custom", "Value_Budget_reverse", each try if Text.Contains(Text.Upper([ID_Key_Item]), "COST") then -[#"Value (kUSD) - Budget"] else [#"Value (kUSD) - Budget"] otherwise [#"Value (kUSD) - Budget"]),
    #"Changed Type1" = Table.TransformColumnTypes(#"Added Custom2",{{"Value_reverse", type number}, {"Value_Budget_reverse", type number}}),
    #"Added Custom1" = Table.AddColumn(#"Changed Type1", "All", each 1),
    #"Changed Type2" = Table.TransformColumnTypes(#"Added Custom1",{{"All", Int64.Type}, {"Value (kUSD) - Budget", type number}}),
    #"Renamed Columns" = Table.RenameColumns(#"Changed Type2",{{"Value_reverse", "Value_reverse_Actual"}, {"Value (kUSD) - Budget", "Budget (kUSD)"}, {"Value_Budget_reverse", "Value_reverse_Budget"}, {"Value (kUSD)", "Actual (kUSD)"}})
in
    #"Renamed Columns"