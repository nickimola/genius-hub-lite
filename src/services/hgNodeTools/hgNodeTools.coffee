angular.module('hgNodeToolsService', [])
.service 'hgNodeTools', [
  ->
    hgNodeTools = this

    NodeDescription = {
      '0x0000000000000000': 'Unrecognised Device'
      '0x0000006000010003': 'Smart Plug'
      '0x0000005900010003': 'Single Channel Receiver'
      '0x0000005900020003': 'Dual Channel Receiver'
      '0x0000005900050003': 'Single Channel Receiver'
      '0x0000005900060003': 'Dual Channel Receiver'
      '0x0000005900030001': 'Room Thermostat'
      '0x0000005900050001': 'Room Thermostat'
      '0x0000000200030005': 'Radiator Valve'
      '0x0000000200040005': 'Radiator Valve'
      '0x00000071035D0002': 'Temperature Sensor'
      '0x0000008600050002': 'Room Sensor'
      '0x0000009600010010': 'Gas Meter Reader'
      '0x0000013C00100001': 'Electric Switch'
      '0x0000013C000F0001': 'Electric Switch'
      '0x0000013C00010001': 'Smart Plug'
      '0x0000013C00110001': 'Smart Plug'
      '0x0000015400011100': 'Smart Plug'
      '0x0000013C00020002': 'Room Sensor'
      '0x0000013C000C0002': 'Room Sensor'
      '0x0000013C000D0002': 'Room Sensor'
      '0x0000000220008004': 'Underfloor Receiver'
      '0x00000081000100A0': 'CO2 Sensor'
      '0x000000590002000D': 'Temperature Sensor'
      '0x0000005900020010': 'Electric Switch'
      '0x0000005900010010': 'Electric Switch'
      '0x0000006000020001': 'Motion Sensor'
      '0x0000006000010006': 'Temperature Humidity Sensor'
      '0x0000013C001A0006': 'In Wall Meter'
      '0x00000002A0107FFF': 'Radiator Valve'
      '0x0000000280100003': 'Room Thermostat'
      'VIRTUAL': 'Virtual Node'
    }

    NodeSKU = {
      '0x0000000000000000': 'N/A'
      '0x0000006000010003': 'EV-PLG-A'
      '0x0000005900010003': 'HO-SCR-C'
      '0x0000005900050003': 'HO-SCR-D'
      '0x0000005900020003': 'HO-DCR-C'
      '0x0000005900060003': 'HO-DCR-D'
      '0x0000005900030001': 'HO-WRT-B'
      '0x0000005900050001': 'HO-WRT-D'
      '0x0000000200030005': 'DA-WRV-A'
      '0x0000000200040005': 'DA-WRV-B'
      '0x00000071035D0002': 'LS-WTS-A'
      '0x0000008600050002': 'AL-WRS-C'
      '0x0000009600010010': 'NQ-UMR-A'
      '0x0000013C00100001': 'PH-ESW-A'
      '0x0000013C000F0001': 'PH-ESW-B'
      '0x0000013C00010001': 'PH-PLG-C'
      '0x0000013C00110001': 'PH-PLG-C'
      '0x0000015400011100': 'PO-PLG-B'
      '0x0000013C00020002': 'PH-WRS-A'
      '0x0000013C000C0002': 'PH-WRS-B'
      '0x0000013C000D0002': 'PH-WRS-B'
      '0x0000000220008004': 'DA-SUR-B'
      '0x00000081000100A0': 'SA-COS-A'
      '0x000000590002000D': 'HO-WRT-A'
      '0x0000005900020010': 'HO-ESW-D'
      '0x0000005900010010': 'HO-ESW-D'
      '0x0000006000020001': 'ES-WMS-A'
      '0x0000006000010006': 'ES-THS-A'
      '0x0000013C001A0006': 'PH-IWM-A'
      '0x00000002A0107FFF': 'DA-WRV-C'
      '0x0000000280100003': 'DA-WRT-C'
      'VIRTUAL': 'Virtual Node'
    }

    zoneModes = {
      Mode_Off: 1
      Mode_Timer: 2
      Mode_Footprint: 4
      Mode_Away: 8
      Mode_Boost: 16
      Mode_Early: 32
      Mode_Test: 64
      Mode_Linked: 128
      Mode_Other: 256
    }

    equipmentTypes = {
      Kit_Temp: 0x0001
      Kit_Valve: 0x0002
      Kit_PIR: 0x0004
      Kit_Power: 0x0008
      Kit_Switch: 0x0010
      Kit_Dimmer: 0x0020
      Kit_Alarm: 0x0040
      Kit_GlobalTemp: 0x0080
      Kit_Humidity: 0x0100
      Kit_Luminance: 0x0200
    }

    zoneFlags = {
      Flag_Frost: 0x0001
      Flag_Timer: 0x0002
      Flag_Footprint: 0x0004
      Flag_Boost: 0x0008
      Flag_Away: 0x0010
      Flag_WarmupAuto: 0x0020
      Flag_WarmupManual: 0x0040
      Flag_Reactive: 0x0080
      Flag_Linked: 0x0100
      Flag_WeatherComp: 0x0200
      Flag_Temps: 0x0400
      Flag_TPI: 0x0800
    }

    splitAddress = (addr) ->
      firstPart = undefined
      frontPart = undefined
      l = undefined
      lastPart = undefined
      parts = undefined
      result = undefined
      parts = addr.split('/')
      l = if parts.length >= 1 then parts.length - 1 else 0
      frontPart = parts.slice(0, l)
      lastPart = parts[l]
      firstPart = frontPart.join('/')
      result = [
        firstPart
        lastPart
      ]

    getSoloDataPoints = (lstDataPoints, lstNodes) ->
      addr = undefined
      bFound = undefined
      dp = undefined
      i = undefined
      j = undefined
      node = undefined
      solo = undefined
      solo = []
      for i of lstDataPoints
        `i = i`
        dp = lstDataPoints[i]
        addr = splitAddress(dp.address)
        tidyAddress = splitAddress(addr[0])
        bFound = false
        dp.address = tidyAddress[1] if tidyAddress
        for j of lstNodes
          `j = j`
          node = lstNodes[j]
          if addr[0] == node.address
            bFound = true
            break
        if !bFound
          solo.push dp
      solo

    soloDataPoints = (lstDataPoints, lstNodes)->
      dataPointsList = getSoloDataPoints(lstDataPoints, lstNodes)
      return dataPointsList

    convertHashToNodeDescription = (hash) ->
      if !(hash?)
        hash = "Unrecognised device"
      #      hash = hash.toLowerCase()
      if NodeDescription.hasOwnProperty(hash)
        NodeDescription[hash]
      else
        if (typeof hash is 'string') and (hash.length > 0) then hash else 'Unknown device'

    convertHashToNodeSKU = (hash) ->
      if !(hash?)
        hash = "Unknown"
      if NodeSKU.hasOwnProperty(hash)
        NodeSKU[hash]
      else
        if (typeof hash is 'string') and (hash.length > 0) then 'Device not found' else 'Device not found'


    tidyAddress = (address) ->
      nodeAddress = splitAddress(address)
      return nodeAddress[1] if nodeAddress

    getNodeHash = (node) ->
      for valueAddress, value of node.childValues
        if value.addr == 'hash'
          return value.val

    getNodeDescription = (node) ->
      return hgNodeTools.convertHashToNodeDescription(getNodeHash(node))

    # Count the number of sub nodes that a node has (excluding the _cfg node if present)
    # @param node
    # @return number of child nodes
    countSubNodes = (node) ->
      result = 0
      for nodeAddress, subNode of node.childNodes
        if nodeAddress == '_cfg' then continue
        result += 1
      return result

    # filterDevices
    #
    # @param data A set of device data provided by /v2/data_manager
    # @return A filtered list of device addresses
    filterDevices = (data, showChildren = false) ->
      result = []
      allowedValues = ['TEMPERATURE', 'HEATING_1', 'SwitchBinary']
      dcr = ['0x0000005900020003', '0x0000005900060003']

      filterNodeAddresses = (parentNode, parentPath, nodeAddress, showChildren) ->
        result = []
        hasSubNodes = false

        for nodeAddress, node of parentNode.childNodes
          if Object.keys(node.childValues).length > 0
            nodeHash = getNodeHash node
            hasSubNodes = hgNodeTools.countSubNodes(node) > 0
            if nodeHash?
              if nodeHash not in dcr
                nodeDescription = convertHashToNodeDescription nodeHash
                result.push {
                  isValue: false
                  nodeId: nodeAddress
                  hash: nodeHash
                  description: nodeDescription
                  path: "#{parentPath}/#{nodeAddress}"
                  node: node
                  tempSelected: false
                  selected: false
                }
              else
                if hasSubNodes
                  for valueAddress, value of node.childNodes
                    node.tempSelected = false
                    node.selected = false
                    if not value.childValues.SwitchBinary? then continue
                    if value.childValues.SwitchBinary.addr in allowedValues
                      pathStack = "#{parentPath}/#{value.addr}".split('/')
                      nodeAddress = value.addr
                      x = {
                        isValue: false
                        nodeId: node.addr
                        hash: getNodeHash(node)
                        description: "Channel #{value.addr} - Dual Channel Receiver"
                        path: "#{parentPath}/#{node.addr}/#{value.addr}"
                        value: value
                        node: node.childNodes[nodeAddress]
                        tempSelected: false
                        selected: if node.childNodes[nodeAddress].childValues.location.val? then true else false
                      }

                      x.node.childValues.parentNodeHash = nodeHash
                      x.node.childValues.isDCRChannel = true

#                      path: "#{parentPath}/#{node.addr}/#{value.addr}/SwitchBinary"

                      # This depends on us knowing the structure of a 'dual channel receiver' type path. We
                      # only want the parent node to be the 'top level' node, not a sub node address
                      if pathStack.length > 2
                        x.parentID = pathStack[2]
                      result.push x

          result = result.concat filterNodeAddresses(node, "#{parentPath}/#{nodeAddress}", nodeAddress, showChildren)

          if showChildren and !hasSubNodes
            if node.childValues.parentNodeHash not in dcr
              for valueAddress, value of node.childValues
                node.tempSelected = false
                node.selected = false
                if value.addr in allowedValues
                  pathStack = "#{parentPath}/#{value.addr}".split('/')
                  x = {
                    isValue: true
                    nodeId: node.addr
                    hash: getNodeHash(node)
                    description: value.addr
                    path: "#{parentPath}/#{node.addr}/#{value.addr}"
                    value: value
                    tempSelected: false
                    selected: false
                  }
                  # This depends on us knowing the structure of a 'dual channel receiver' type path. We
                  # only want the parent node to be the 'top level' node, not a sub node address
                  if pathStack.length > 2
                    x.parentID = pathStack[2]
                  result.push x

        return result

      result = filterNodeAddresses(data, data.addr, data.nodeID, showChildren)
      return result


    prettifyDeviceAddressObj = (address) ->
      re = /(site\/)?(0x[A-Fa-f0-9]{8})(?:[:/]([0-9]{1,3})(?:[:/]([a-zA-Z0-9]+)?(?:[/\.]([a-zA-Z0-9]+))?)?)?/
      result = address.match(re)
      x = {
        site: null
        homeID: null
        nodeID: address
        subNode: null
        value: null
      }
      if result? and result.length >= 4
        x = {
          site: result[1]
          homeID: result[2]
          nodeID: result[3]
          subNode: null
          value: null
        }

        if result[5] is null
          x.value = result[4]
        else
          x.subNode = result[4]
          x.value = result[5]

      return x

    prettifyDeviceAddress = (address) ->
      return address.split('/')

    assignDevice = (data) ->
      nodeList = []
      angular.forEach data.childNodes, (zWaveNode) ->
        angular.forEach zWaveNode.childNodes, (zWaveDeviceNode) ->
          angular.forEach zWaveDeviceNode.childValues, (value) ->
            if value.addr == "hash"
              nodeDescription = hgNodeTools.convertHashToNodeDescription(value.val)
              nodeList.push {
                nodeId: zWaveDeviceNode.addr
                hash: value.val
                description: nodeDescription
                path: value.path
              }
      return nodeList

    checkIssuesID = (id) ->
      reg = /^\d+$/;
      if id.match reg
        return id
      else
        return "-"


    getNodeIssueAsString = (id, data) ->
      if data?
        desc = hgNodeTools.convertHashToNodeDescription(data.nodeHash)

      switch id
        when 'node:no_comms'
          obj = {
            id: checkIssuesID(data.nodeID)
            location: data.location
            description: desc
            details: ''
            message: 'has lost communication with the Hub'
          }
          return obj

        when 'node:not_seen'
          obj = {
            id: checkIssuesID(data.nodeID)
            location: data.location
            description: desc
            details: ''
            message: 'has not been found by the Hub'
          }
          return obj

        when 'node:low_battery'
          obj = {
            id: checkIssuesID(data.nodeID)
            location: data.location
            description: desc
            details: ''
            message: 'battery is dead and needs to be replaced'
          }
          return obj

        when 'node:warn_battery'
          obj = {
            id: checkIssuesID(data.nodeID)
            location: data.location
            description: desc
            details: data.batteryLevel
            message: 'battery is low'
          }
          return obj

        when 'manager:no_boiler_controller'
          obj = {
            id: ''
            location: ''
            description: ''
            details: ''
            message: 'My House does not have a boiler controller assigned'
          }
          return obj

        when 'manager:no_boiler_comms'
          obj = {
            id: ''
            location: ''
            description:''
            details: ''
            message: 'Hub has lost communication with the boiler controller'
          }
          return obj

        when 'manager:no_temp'
          obj = {
            id: ''
            location: ''
            description:''
            details: ''
            message: 'My House does not have a valid temperature'
          }
          return obj

        when 'manager:weather_data'
          obj = {
            id: ''
            location: data.location
            description: desc
            details: data.detail
            message: 'Weather data -'
          }
          return obj

        when 'zone:using_weather_temp'
          obj = {
            id: ''
            location: ''
            description: ''
            details: ''
            message: "The #{data.zone.strName} zone is currently using the outside temperature"
          }
          return obj

        when 'zone:using_assumed_temp'
          obj = {
            id: ''
            location: ''
            description: ''
            details: ''
            message: "The #{data.zone.strName} zone is currently using the assumed temperature (as specified on the settings page)"
          }
          return obj

        when 'zone:tpi_no_temp'
          obj = {
            id: ''
            location: ''
            description: ''
            details: ''
            message: "The #{data.zone.strName} zone has no valid temperature sensor"
          }
          return obj

        else
          return

    assembleZoneIssueList = (zones) ->
      issueList = []

      if zones?[0]?
        zonesObject = _.keyBy(zones, 'iID')
        dualChannelSwitchBinaryMappings = {}
        for key, array of zonesObject[0].mappings
          for mapping in array
            # APPV5-670 Fixes error when mappings contain zones which don't exist
            if zonesObject[parseInt(key)]? and mapping.match(/\/[0-9]+\/[0-9]+\/SwitchBinary/)
              dualChannelSwitchBinaryMappings[mapping] = dualChannelSwitchBinaryMappings[mapping] or []
              dualChannelSwitchBinaryMappings[mapping].push(
                id: parseInt(key)
                name: zonesObject[parseInt(key)].strName
                nodeId: mapping.match(/\/([0-9]+)\/[0-9]+\/SwitchBinary/)[1]
                channelId: mapping.match(/\/[0-9]+\/([0-9]+)\/SwitchBinary/)[1]
              )
        for key, mapping of dualChannelSwitchBinaryMappings
          if mapping.length > 1
            [first, middle..., last] = mapping.map (x) -> x.name
            location = first
            for zone in middle
              location += ", #{zone}"
            location += " and #{last}"

            issueList.push {
              roomID: mapping[0].id
              errorObj:
                id: 'node:assignment_limit_exceeded'
                level: 2
                data: {location: mapping[0].name, nodeHash: '0x0000005900020003', nodeID: mapping[0].nodeId}
              humanMessage:
                location: location
                id: mapping[0].nodeId
                description: "Dual Channel Receiver (Channel #{mapping[0].channelId})"
                details: ''
                message: 'has been assigned to too many zones'
            }

        for zone in zones
          for issue in zone.lstIssues
            issueList.push {
              roomID: zone.iID
              errorObj: issue
              humanMessage: getNodeIssueAsString(issue.id, issue.data or {zone}, issue.level)
            }

      return issueList


    return hgNodeTools = {
      tidyAddress: tidyAddress
      convertHashToNodeDescription: convertHashToNodeDescription
      soloDataPoints: soloDataPoints
      assignDevice: assignDevice
      filterDevices: filterDevices
      getNodeHash: getNodeHash
      getNodeDescription: getNodeDescription
      prettifyDeviceAddress: prettifyDeviceAddress
      prettifyDeviceAddressObj: prettifyDeviceAddressObj
      equipmentTypes: equipmentTypes
      zoneFlags: zoneFlags
      zoneModes: zoneModes
      assembleZoneIssueList: assembleZoneIssueList
      convertHashToNodeSKU: convertHashToNodeSKU
      countSubNodes: countSubNodes
    }

]
