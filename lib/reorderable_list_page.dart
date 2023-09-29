import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'reorderable_item_list_controller.dart';

class ReorderableListPage extends StatelessWidget {
  final ItemController controller = Get.put(ItemController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ReorderableListView with Search'),
      ),
      body: Obx(() => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller.searchController,
              onChanged: (query) {
                controller.searchQuery = query;
                controller.scrollToItem(query);
              },
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Search items...',
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    controller.clearSearch();
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: ReorderableListView(
              scrollController: controller.scrollController,
              onReorder: (oldIndex, newIndex) {
                final itemToReorder = controller.items.removeAt(oldIndex);
                print('ReorderIndex -> $newIndex ** $oldIndex');
                controller.items
                  ..insert(newIndex, itemToReorder)
                  ..refresh();
              },
              children: <Widget>[
                for (int i = 0; i < controller.items.length; i++)
                  Builder(
                    key: Key(controller.items[i]),
                    builder: (context) {
                      final item = controller.items[i];
                      final isHighlighted = controller.searchQuery.isNotEmpty &&
                          item.contains(controller.searchQuery);

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        key: Key(item),
                        color: isHighlighted
                            ? Colors.blue.withOpacity(0.3)
                            : Colors.transparent,
                        child: ListTile(
                          key: Key(item),
                          title: Text(item),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),),
    );
  }
}

/*class ReorderableListViewWithSearch extends StatefulWidget {
  const ReorderableListViewWithSearch({Key? key}) : super(key: key);

  @override
  _ReorderableListViewWithSearchState createState() =>
      _ReorderableListViewWithSearchState();
}

class _ReorderableListViewWithSearchState
    extends State<ReorderableListViewWithSearch> {
  List<String> items = List.generate(50, (index) => 'MItem $index');
  int reorderIndex = -1;
  TextEditingController searchController = TextEditingController();
  final _scrollController = ScrollController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
  }

  void _scrollToItem(String query) {
    if (query.isEmpty) return;

    final matchingItemIndex = items.indexWhere((item) => item.contains(query));
    if (matchingItemIndex != -1) {
      _scrollController.animateTo(
        matchingItemIndex * 56.0, // Assuming ListTile height is 56
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _reorderItem(int oldIndex, int newIndex) {
    setState(() {
      final itemToReorder = items[oldIndex];
      items.removeAt(oldIndex);
      items.insert(newIndex, itemToReorder);
      reorderIndex = newIndex;
      searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ReorderableListView with Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (query) {
                searchQuery = query;
                _scrollToItem(query);
              },
              decoration: const InputDecoration(
                labelText: 'Search',
                hintText: 'Search items...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ReorderableListView(
              scrollController: _scrollController,
              onReorder: _reorderItem,
              children: <Widget>[
                for (int i = 0; i < items.length; i++)
                  Builder(
                    key: Key('Builder_${items[i]}'),
                    builder: (context) {
                      final item = items[i];
                      final isHighlighted =
                          searchQuery.isNotEmpty && item.contains(searchQuery);

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        key: Key(item),
                        color: isHighlighted
                            ? Colors.blue.withOpacity(0.3)
                            : Colors.transparent,
                        child: ListTile(
                          title: Text(item),
                          onTap: () {
                            setState(() {
                              reorderIndex = i;
                            });
                          },
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}*/
