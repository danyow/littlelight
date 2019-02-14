import 'package:bungie_api/models/destiny_character_component.dart';
import 'package:flutter/material.dart';
import 'package:little_light/services/bungie_api/enums/item_category.enum.dart';
import 'package:little_light/services/manifest/manifest.service.dart';
import 'package:little_light/services/profile/profile.service.dart';
import 'package:little_light/utils/selected_page_persistence.dart';
import 'package:little_light/widgets/inventory_tabs/character_tab.widget.dart';
import 'package:little_light/widgets/inventory_tabs/inventory_notification.widget.dart';
import 'package:little_light/widgets/inventory_tabs/selected_items.widget.dart';
import 'package:little_light/widgets/inventory_tabs/tabs_character_menu.widget.dart';
import 'package:little_light/widgets/inventory_tabs/tabs_item_type_menu.widget.dart';
import 'package:little_light/widgets/inventory_tabs/vault_tab.widget.dart';
import 'package:little_light/widgets/progress_tabs/character_progress_tab.widget.dart';

class ProgressScreen extends StatefulWidget {
  final profile = new ProfileService();
  final manifest = new ManifestService();
  final List<int> itemTypes = [
    ItemCategory.weapon,
    ItemCategory.armor,
    ItemCategory.inventory
  ];

  @override
  ProgressScreenState createState() => new ProgressScreenState();
}

class ProgressScreenState extends State<ProgressScreen>
    with TickerProviderStateMixin {
  Map<int, double> scrollPositions = new Map();

  TabController charTabController;
  TabController typeTabController;

  get totalCharacterTabs =>
      characters?.length != null ? characters.length + 1 : 4;

  @override
  void initState() {
    SelectedPagePersistence.saveLatestScreen(SelectedPagePersistence.equipment);

    widget.itemTypes.forEach((type) {
      scrollPositions[type] = 0;
    });
    widget.profile.startAutomaticUpdater(Duration(seconds: 30));
    super.initState();
    
  }

  @override
  void dispose() {
    widget.profile.stopAutomaticUpdater();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    charTabController = charTabController ?? TabController(
      initialIndex: 0,
      length: totalCharacterTabs,
      vsync: this,
    );
    if (characters == null) {
      return Container();
    }
    double paddingTop = MediaQuery.of(context).padding.top;
    return Material(
      child: Stack(
        children: <Widget>[
          buildBackground(context),
          TabBarView(
              controller: charTabController,
              children: getTabs()),
          Positioned(
            top: paddingTop,
            width: kToolbarHeight,
            height: kToolbarHeight,
            child: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
          TabsCharacterMenuWidget(characters, controller: charTabController),
        ],
      ),
    );
  }

  Widget buildBackground(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
      colors: [
        Color.fromARGB(255, 32, 53, 53),
        Color.fromARGB(255, 100, 100, 115),
        Color.fromARGB(255, 32, 32, 73),
      ],
      begin: FractionalOffset(0, .5),
      end: FractionalOffset(.5, 0),
    )));
  }

  List<Widget> getTabs() {
    List<Widget> characterTabs = characters.map((character) {
      return CharacterProgressTabWidget(character.characterId);
    }).toList();
    
    return characterTabs;
  }

  List<DestinyCharacterComponent> get characters {
    return widget.profile.getCharacters(CharacterOrder.lastPlayed);
  }
}