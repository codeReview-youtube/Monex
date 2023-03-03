import React, {FC, useState, useEffect} from 'react';
import {
  SafeAreaView,
  ScrollView,
  StatusBar,
  View,
  TextInput,
  Button,
  Text,
  StyleSheet,
  ActivityIndicator,
  NativeModules,
} from 'react-native';

const API_KEY = '';
const BASE_URL = 'https://api.apilayer.com/exchangerates_data';
const {RNSharedWidget} = NativeModules


export const App: FC = () => {
  const [from, setFrom] = useState('EUR');
  const [to, setTo] = useState('USD');
  const [amount, setAmount] = useState('100');
  const [loading, setLoading] = useState(false);
  const [focusItem, setFocusItem] = useState('');

  const [result, setResult] = useState(0);

  useEffect(() => {
    if (result === 0) getData();
  }, [result]);

  const getData = async () => {
    setLoading(true);
    try {
      let response;
      const request = await fetch(
        BASE_URL + `/convert?to=${to}&from=${from}&amount=${amount}`,
        {
          method: 'GET',
          headers: {
            apiKey: API_KEY,
            'Content-Type': 'application/json',
          },
        },
      );
      if (request.status === 200) {
        response = await request.json();
      }
      if (response && response.result) {
        /** result scheme of api response 
         * {
          "date": "2023-02-28",
          "info": {
            "rate": 1.058762,
            "timestamp": 1677612543
          },
          "query": {
            "amount": 100,
            "from": "EUR",
            "to": "USD"
          },
          "result": 105.8762,
          "success": true
        }
        */
        setResult((response.result as any).toFixed(2));
        setLoading(false);
        RNSharedWidget.setData('convertorMonex', 
        JSON.stringify({
          from,
          to,
          amount: Number(amount),
          result: response.result ?? 0,
        }), 
        (status: number | null) => {
          console.log('------------------------------');
          console.log("Status: ", status);
          console.log('------------------------------');
        });
      }
    } catch (e) {}
  };

  const onSubmit = () => {
    getData();
  };

  const getColor = (item: string) => {
    return focusItem === item
      ? {
          borderColor: 'green',
          borderWidth: 2,
        }
      : {};
  };

  return (
    <SafeAreaView>
      <StatusBar />
      <ScrollView contentContainerStyle={styles.container}>
        <View testID="input view section">
          <View testID="form" style={styles.fieldsContainer}>
            <TextInput
              placeholder="100"
              value={amount}
              onChange={txt => setAmount(txt as any)}
              style={[styles.input, getColor('amount')]}
              onFocus={() => setFocusItem('amount')}
              focusable={focusItem === 'amount'}
            />
            <TextInput
              onChange={txt => setFrom(txt as any)}
              value={from}
              placeholder="EUR"
              style={[styles.input, getColor('from')]}
              onFocus={() => setFocusItem('from')}
              focusable={focusItem === 'from'}
            />
            <TextInput
              value={to}
              onChange={txt => setTo(txt as any)}
              placeholder="USD"
              style={[styles.input, getColor('to')]}
              onFocus={() => setFocusItem('to')}
              focusable={focusItem === 'to'}
            />
            <Button title="Submit" onPress={onSubmit} disabled={loading} />
          </View>
        </View>
        <View testID="view selection section" style={styles.resultContainer}>
          {loading ? (
            <ActivityIndicator size="large" color="white" />
          ) : (
            <Text style={styles.result}>{result}</Text>
          )}
        </View>
      </ScrollView>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    padding: 20,
  },
  resultContainer: {
    padding: 30,
    height: 300,
    backgroundColor: '#996',
    borderRadius: 5,
    marginBottom: 10,
    justifyContent: 'center',
    alignItems: 'center',
  },
  fieldsContainer: {
    marginVertical: 30,
  },
  input: {
    padding: 10,
    borderRadius: 5,
    fontSize: 20,
    marginBottom: 10,
    fontWeight: 'bold',
    borderColor: 'grey',
    borderWidth: 1,
  },
  result: {
    fontSize: 40,
    fontWeight: 'bold',
  },
});
