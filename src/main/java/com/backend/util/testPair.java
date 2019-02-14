package com.backend.util;

import java.util.ArrayList;

public class testPair {

	public static void main(String[] args) {
		ArrayList<Pair> EPS = new ArrayList<Pair>();
		Pair orbitType = new Pair("orbit-type","SSO");
		Pair payloadPower = new Pair("payload-power","120");
		EPS.add(orbitType);
		EPS.add(payloadPower);
		System.out.println(EPS.get(EPS.indexOf(payloadPower)).value());
	}

}
