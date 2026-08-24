import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchBox extends StatefulWidget{
    final ValueChanged<String> onChanged;
    const SearchBox({
            super.key,
            required this.onChanged,
    });

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
    final TextEditingController searchController = TextEditingController();

    @override
    void dispose(){
        searchController.dispose();
        super.dispose();
    }
    @override
    void initState() {
        super.initState();
        Future.microtask(() {
        
        });
    }
  
  @override
  Widget build(BuildContext context) {
        return TextField(
            controller: searchController,
            onChanged:(value) {
                widget.onChanged(value);
            },
            decoration: InputDecoration(
                hintText: 'Search for produce...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                onPressed: () {
                    searchController.clear();
                    widget.onChanged('');
                    setState(() {});
                },
                icon: const Icon(Icons.tune),
                ),
            ),
        ); 
  }
}