
import 'package:flutter/material.dart';

void main() {
  runApp(const LoopBackApp());
}

const forestGreen = Color(0xFF176B45);
const mintGreen = Color(0xFFE3F4E9);
const pageBackground = Color(0xFFF7F9F6);

class LoopItem {
  final String id;
  final String name;
  final String category;
  final String condition;
  final String type;
  final String description;
  final IconData icon;

  LoopItem({
    required this.id,
    required this.name,
    required this.category,
    required this.condition,
    required this.type,
    required this.description,
    required this.icon,
  });
}

class LoopBackApp extends StatelessWidget {
  const LoopBackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LoopBack',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: pageBackground,
        colorScheme: ColorScheme.fromSeed(
          seedColor: forestGreen,
          primary: forestGreen,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: pageBackground,
          foregroundColor: forestGreen,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedTab = 0;
  String selectedCategory = 'All';
  String searchText = '';

  final Set<String> requestedIds = {};

  int reusedCount = 12;
  int greenPoints = 120;

  final List<LoopItem> items = [
    LoopItem(
      id: '1',
      name: 'Engineering Mathematics',
      category: 'Books',
      condition: 'Good',
      type: 'Donate',
      description: 'Useful textbook for engineering students.',
      icon: Icons.menu_book_rounded,
    ),
    LoopItem(
      id: '2',
      name: 'Scientific Calculator',
      category: 'Electronics',
      condition: 'Like New',
      type: 'Borrow',
      description: 'Scientific calculator available for college use.',
      icon: Icons.calculate_rounded,
    ),
    LoopItem(
      id: '3',
      name: 'Lab Coat',
      category: 'Lab Items',
      condition: 'Good',
      type: 'Exchange',
      description: 'Clean lab coat available for another student.',
      icon: Icons.science_rounded,
    ),
    LoopItem(
      id: '4',
      name: 'Notebook Set',
      category: 'Stationery',
      condition: 'Good',
      type: 'Donate',
      description: 'Extra notebooks with unused pages.',
      icon: Icons.edit_note_rounded,
    ),
    LoopItem(
      id: '5',
      name: 'USB Cable',
      category: 'Electronics',
      condition: 'Good',
      type: 'Borrow',
      description: 'Reusable USB cable for everyday student needs.',
      icon: Icons.cable_rounded,
    ),
  ];

  final List<String> categories = [
    'All',
    'Books',
    'Electronics',
    'Lab Items',
    'Stationery',
  ];

  void addNewItem(LoopItem item) {
    setState(() {
      items.insert(0, item);
      selectedTab = 1;
      selectedCategory = 'All';
    });
  }

  void requestItem(LoopItem item) {
    if (requestedIds.contains(item.id)) return;

    setState(() {
      requestedIds.add(item.id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Request submitted! Status: Pending'),
      ),
    );
  }

  void showItemDetails(LoopItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: pageBackground,
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 42,
                  backgroundColor: mintGreen,
                  child: Icon(
                    item.icon,
                    size: 42,
                    color: forestGreen,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                item.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text('${item.category} • ${item.condition}'),
              const SizedBox(height: 12),
              Text(item.description),
              const SizedBox(height: 12),
              Chip(
                label: Text(item.type),
                backgroundColor: mintGreen,
              ),
              const SizedBox(height: 16),
              if (requestedIds.contains(item.id))
                const Text(
                  'Your request status: Pending',
                  style: TextStyle(
                    color: forestGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: requestedIds.contains(item.id)
                      ? null
                      : () {
                          Navigator.pop(sheetContext);
                          requestItem(item);
                        },
                  child: Text(
                    requestedIds.contains(item.id)
                        ? 'Request Sent'
                        : 'Request Item',
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = items.where((item) {
      final matchesCategory = selectedCategory == 'All' ||
          item.category == selectedCategory;

      final matchesSearch = item.name
          .toLowerCase()
          .contains(searchText.toLowerCase());

      return matchesCategory && matchesSearch;
    }).toList();

    final pages = [
      buildHome(filteredItems),
      buildExplore(filteredItems),
      AddItemScreen(onAdd: addNewItem),
      buildImpact(),
      buildProfile(),
    ];

    return Scaffold(
      body: SafeArea(child: pages[selectedTab]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedTab,
        onDestinationSelected: (index) {
          setState(() {
            selectedTab = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_rounded),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline_rounded),
            selectedIcon: Icon(Icons.add_circle_rounded),
            label: 'Add Item',
          ),
          NavigationDestination(
            icon: Icon(Icons.eco_outlined),
            selectedIcon: Icon(Icons.eco_rounded),
            label: 'Impact',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget buildHome(List<LoopItem> filteredItems) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Row(
          children: [
            const CircleAvatar(
              backgroundColor: mintGreen,
              child: Icon(Icons.eco_rounded, color: forestGreen),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'LoopBack',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: forestGreen,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() => selectedTab = 4);
              },
              icon: const Icon(Icons.account_circle_outlined),
            ),
          ],
        ),
        const SizedBox(height: 22),
        const Text(
          'Reuse more, waste less.',
          style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        const Text(
          'Find useful items within your college community.',
          style: TextStyle(color: Colors.black54),
        ),
        const SizedBox(height: 22),
        TextField(
          onChanged: (value) {
            setState(() => searchText = value);
          },
          decoration: const InputDecoration(
            hintText: 'Search books, calculators...',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        const SizedBox(height: 22),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: forestGreen,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Small actions,\nbig impact 🌱',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Give your unused items a new life.',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.recycling_rounded,
                size: 64,
                color: Colors.white,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const SectionHeading(title: 'Browse Categories'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories.map((category) {
            return ActionChip(
              label: Text(category),
              backgroundColor:
                  selectedCategory == category ? mintGreen : Colors.white,
              onPressed: () {
                setState(() {
                  selectedCategory = category;
                  selectedTab = 1;
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        SectionHeading(
          title: 'Recently Listed',
          onSeeAll: () => setState(() => selectedTab = 1),
        ),
        const SizedBox(height: 12),
        ...filteredItems.take(3).map(
              (item) => ItemCard(
                item: item,
                requested: requestedIds.contains(item.id),
                onTap: () => showItemDetails(item),
              ),
            ),
        const SizedBox(height: 16),
        ImpactMiniCard(
          reusedCount: reusedCount,
          onTap: () => setState(() => selectedTab = 3),
        ),
      ],
    );
  }

  Widget buildExplore(List<LoopItem> filteredItems) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Explore Items',
          style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text('Discover something useful from another student.'),
        const SizedBox(height: 18),
        TextField(
          onChanged: (value) {
            setState(() => searchText = value);
          },
          decoration: const InputDecoration(
            hintText: 'Search items',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        const SizedBox(height: 14),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: categories.map((category) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(category),
                  selected: selectedCategory == category,
                  onSelected: (_) {
                    setState(() => selectedCategory = category);
                  },
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 14),
        if (filteredItems.isEmpty)
          const Padding(
            padding: EdgeInsets.all(30),
            child: Center(child: Text('No matching items found.')),
          ),
        ...filteredItems.map(
          (item) => ItemCard(
            item: item,
            requested: requestedIds.contains(item.id),
            onTap: () => showItemDetails(item),
          ),
        ),
      ],
    );
  }

  Widget buildImpact() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Your Green Impact',
          style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text('Every reused item is a step towards less waste.'),
        const SizedBox(height: 24),
        ImpactMiniCard(
          reusedCount: reusedCount,
          onTap: () {},
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'Items Listed',
                value: '${items.length}',
                icon: Icons.inventory_2_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                title: 'Requests Made',
                value: '${requestedIds.length}',
                icon: Icons.volunteer_activism_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        StatCard(
          title: 'Green Points',
          value: '$greenPoints',
          icon: Icons.stars_rounded,
        ),
        const SizedBox(height: 22),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: mintGreen,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.emoji_events_rounded, size: 36, color: forestGreen),
              SizedBox(height: 10),
              Text(
                'Campus Eco Starter',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 6),
              Text('Keep sharing, donating and reusing student essentials.'),
            ],
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'Demo note: reuse and points values are prototype data.',
          style: TextStyle(color: Colors.black54, fontSize: 12),
        ),
      ],
    );
  }

  Widget buildProfile() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'My Profile',
          style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        const Center(
          child: CircleAvatar(
            radius: 44,
            backgroundColor: mintGreen,
            child: Icon(Icons.person_rounded, size: 48, color: forestGreen),
          ),
        ),
        const SizedBox(height: 12),
        const Center(
          child: Text(
            'LoopBack Student',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        const Center(
          child: Text(
            'College Community Member',
            style: TextStyle(color: Colors.black54),
          ),
        ),
        const SizedBox(height: 24),
        StatCard(
          title: 'Items Listed',
          value: '${items.length}',
          icon: Icons.inventory_2_outlined,
        ),
        const SizedBox(height: 12),
        StatCard(
          title: 'Requests Made',
          value: '${requestedIds.length}',
          icon: Icons.send_outlined,
        ),
        const SizedBox(height: 12),
        StatCard(
          title: 'Green Points',
          value: '$greenPoints',
          icon: Icons.stars_rounded,
        ),
        const SizedBox(height: 20),
        const ListTile(
          leading: Icon(Icons.verified_outlined, color: forestGreen),
          title: Text('Campus Eco Starter'),
          subtitle: Text('Your sustainability badge'),
          tileColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
      ],
    );
  }
}

class AddItemScreen extends StatefulWidget {
  final ValueChanged<LoopItem> onAdd;

  const AddItemScreen({super.key, required this.onAdd});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  String category = 'Books';
  String condition = 'Good';
  String type = 'Donate';

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void submitForm() {
    if (!formKey.currentState!.validate()) return;

    final item = LoopItem(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: nameController.text.trim(),
      category: category,
      condition: condition,
      type: type,
      description: descriptionController.text.trim(),
      icon: category == 'Books'
          ? Icons.menu_book_rounded
          : category == 'Electronics'
              ? Icons.devices_rounded
              : category == 'Lab Items'
                  ? Icons.science_rounded
                  : Icons.edit_note_rounded,
    );

    widget.onAdd(item);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Your item has been listed!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Give Items a New Life',
          style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text('List an item another student can use.'),
        const SizedBox(height: 24),
        Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Item Name'),
              const SizedBox(height: 8),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: 'e.g. Engineering textbook',
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty
                        ? 'Please enter an item name'
                        : null,
              ),
              const SizedBox(height: 18),
              const Text('Category'),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: category,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: 'Books', child: Text('Books')),
                  DropdownMenuItem(
                    value: 'Electronics',
                    child: Text('Electronics'),
                  ),
                  DropdownMenuItem(
                    value: 'Lab Items',
                    child: Text('Lab Items'),
                  ),
                  DropdownMenuItem(
                    value: 'Stationery',
                    child: Text('Stationery'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => category = value);
                },
              ),
              const SizedBox(height: 18),
              const Text('Condition'),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: condition,
                items: const [
                  DropdownMenuItem(value: 'Like New', child: Text('Like New')),
                  DropdownMenuItem(value: 'Good', child: Text('Good')),
                  DropdownMenuItem(value: 'Fair', child: Text('Fair')),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => condition = value);
                },
              ),
              const SizedBox(height: 18),
              const Text('Description'),
              const SizedBox(height: 8),
              TextFormField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Describe your item...',
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty
                        ? 'Please enter a description'
                        : null,
              ),
              const SizedBox(height: 18),
              const Text('How can another student use it?'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ['Donate', 'Borrow', 'Exchange'].map((value) {
                  return ChoiceChip(
                    label: Text(value),
                    selected: type == value,
                    onSelected: (_) => setState(() => type = value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: submitForm,
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text('Publish Listing'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ItemCard extends StatelessWidget {
  final LoopItem item;
  final bool requested;
  final VoidCallback onTap;

  const ItemCard({
    super.key,
    required this.item,
    required this.requested,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: Color(0xFFE7ECE7)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            color: mintGreen,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(item.icon, size: 30, color: forestGreen),
        ),
        title: Text(
          item.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            '${item.category} • ${item.condition}\n'
            '${requested ? 'Request: Pending' : item.type}',
          ),
        ),
        isThreeLine: true,
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
      ),
    );
  }
}

class SectionHeading extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;

  const SectionHeading({super.key, required this.title, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
        ),
        if (onSeeAll != null)
          TextButton(onPressed: onSeeAll, child: const Text('See all')),
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: mintGreen,
            child: Icon(icon, color: forestGreen),
          ),
          const SizedBox(width: 14),
          Expanded(child: Text(title)),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: forestGreen,
            ),
          ),
        ],
      ),
    );
  }
}

class ImpactMiniCard extends StatelessWidget {
  final int reusedCount;
  final VoidCallback onTap;

  const ImpactMiniCard({
    super.key,
    required this.reusedCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: mintGreen,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.recycling_rounded,
              size: 42,
              color: forestGreen,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Campus reuse impact',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text('$reusedCount items reused in demo data'),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16),
          ],
        ),
      ),
    );
  }
}
