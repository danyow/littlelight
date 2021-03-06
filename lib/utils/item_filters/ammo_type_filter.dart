import 'package:bungie_api/enums/destiny_ammunition_type.dart';
import 'package:bungie_api/models/destiny_inventory_item_definition.dart';
import 'package:little_light/utils/item_with_owner.dart';

import 'base_item_filter.dart';

class AmmoTypeFilter extends BaseItemFilter<Set<DestinyAmmunitionType>> {
  AmmoTypeFilter() : super(Set(), Set());

  @override
  Future<List<ItemWithOwner>> filter(List<ItemWithOwner> items, {Map<int, DestinyInventoryItemDefinition> definitions}) async {
    availableValues.clear();
    List<DestinyAmmunitionType> tags = items.map((i){
      var def = definitions[i?.item?.itemHash];
      return def?.equippingBlock?.ammoType ?? DestinyAmmunitionType.None;
    }).toSet().toList();
    tags.sort((a,b)=>a?.index?.compareTo(b?.index ?? -1) ?? 0);
    this.availableValues = tags.toSet();
    this.available = availableValues.length > 1;
    value.retainAll(availableValues);
    if(value.length == 0) return items;
    return super.filter(items, definitions:definitions);
  }

  @override
  bool filterItem(ItemWithOwner item,
      {Map<int, DestinyInventoryItemDefinition> definitions}) {
    var def = definitions[item?.item?.itemHash];
    return value.contains(def?.equippingBlock?.ammoType);
  }
  
}
